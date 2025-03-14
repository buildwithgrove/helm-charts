#!/bin/bash
#
# TODO_IMPROVE(@adshmh): mimic the interface from Claude Code:
# https://github.com/anthropics/claude-code
#
###############################################################################
# PATH Configuration Script
#
# This script helps create Kubernetes ConfigMap or Secret resources from a local
# configuration file, then deploy the PATH Helm chart to use that configuration.
#
# It creates the required Kubernetes resource and configures the PATH Helm chart
# to mount the configuration at /app/config/.config.yaml in the PATH container.
###############################################################################

# Default values
NAMESPACE="default"
RELEASE_NAME="path"
CONFIG_FILE=""
USE_SECRET=true
HELM_ARGS=()
HAS_VALUES_FILE=false

print_usage() {
  echo "PATH Configuration Helper Script"
  echo "================================"
  echo ""
  echo "This script creates a Kubernetes ConfigMap or Secret from a local config file,"
  echo "then deploys the PATH Helm chart configured to use that resource."
  echo ""
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Required:"
  echo "  -c, --config FILE            Path to local .config.yaml file"
  echo ""
  echo "Options:"
  echo "  -n, --namespace NAMESPACE    Kubernetes namespace (default: default)"
  echo "  -r, --release-name NAME      Helm release name (default: path)"
  echo "  -m, --configmap              Use a ConfigMap instead of Secret (default: Secret)"
  echo "  -h, --help                   Show this help message"
  echo ""
  echo "Any additional arguments are passed directly to helm."
  echo "Use -f/--values as you normally would with helm to specify values files."
  echo "If no values file is specified, values.yaml from the current directory will be used."
  echo ""
  echo "Examples:"
  echo "  # Create a Secret and deploy PATH with default values.yaml"
  echo "  $0 --config /path/to/.config.yaml --namespace my-namespace"
  echo ""
  echo "  # Create a ConfigMap and deploy PATH with custom values files"
  echo "  $0 --config /path/to/.config.yaml -f values1.yaml -f values2.yaml --configmap"
  echo ""
  echo "  # Pass additional arguments to helm"
  echo "  $0 --config /path/to/.config.yaml --atomic --timeout 5m"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -n|--namespace)
      NAMESPACE="$2"
      shift 2
      ;;
    -r|--release-name)
      RELEASE_NAME="$2"
      shift 2
      ;;
    -c|--config)
      CONFIG_FILE="$2"
      shift 2
      ;;
    -m|--configmap)
      USE_SECRET=false
      shift 1
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    -f|--values)
      # Mark that we have at least one values file specified
      HAS_VALUES_FILE=true
      HELM_ARGS+=("$1" "$2")
      shift 2
      ;;
    *)
      # Collect all other arguments to pass to helm
      HELM_ARGS+=("$1")
      shift
      ;;
  esac
done

# Check if config file is specified
if [ -z "$CONFIG_FILE" ]; then
  echo "Error: Config file is required. Use -c or --config to specify."
  print_usage
  exit 1
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Config file $CONFIG_FILE does not exist."
  exit 1
fi

# Set resource names based on the release name
CONFIG_NAME="${RELEASE_NAME}-config"

# Create the namespace if it doesn't exist
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

# Create the ConfigMap or Secret based on the user's choice
if [ "$USE_SECRET" = true ]; then
  echo "Creating Secret '$CONFIG_NAME' in namespace '$NAMESPACE' from file '$CONFIG_FILE'..."
  kubectl create secret generic "$CONFIG_NAME" \
    --namespace "$NAMESPACE" \
    --from-file=.config.yaml="$CONFIG_FILE" \
    --dry-run=client -o yaml | kubectl apply -f -
    
  # Use the Secret for PATH configuration
  CONFIG_TYPE="fromSecret"
else
  echo "Creating ConfigMap '$CONFIG_NAME' in namespace '$NAMESPACE' from file '$CONFIG_FILE'..."
  kubectl create configmap "$CONFIG_NAME" \
    --namespace "$NAMESPACE" \
    --from-file=.config.yaml="$CONFIG_FILE" \
    --dry-run=client -o yaml | kubectl apply -f -
    
  # Use the ConfigMap for PATH configuration
  CONFIG_TYPE="fromConfigMap"
fi

# Create a temporary values file that just contains our configuration
TEMP_VALUES=$(mktemp)

# Add minimal configuration to values file
cat > "$TEMP_VALUES" << EOF
# PATH configuration added by install script
config:
  fromConfigMap:
    enabled: $([ "$USE_SECRET" = true ] && echo "false" || echo "true")
    name: "$CONFIG_NAME"
    key: ".config.yaml"
  fromSecret:
    enabled: $([ "$USE_SECRET" = true ] && echo "true" || echo "false")
    name: "$CONFIG_NAME"
    key: ".config.yaml"
EOF

# Build helm command base
HELM_CMD=("helm" "upgrade" "--install" "$RELEASE_NAME" "." "--namespace" "$NAMESPACE" "--create-namespace")

# If no values file was specified and values.yaml exists in current directory, use it
if [ "$HAS_VALUES_FILE" = false ] && [ -f "values.yaml" ]; then
  echo "No values file specified, using values.yaml from current directory..."
  HELM_CMD+=("--values" "values.yaml")
fi

# Add all collected helm arguments
if [ ${#HELM_ARGS[@]} -gt 0 ]; then
  HELM_CMD+=("${HELM_ARGS[@]}")
fi

# Add our config values file last to ensure it takes precedence
HELM_CMD+=("--values" "$TEMP_VALUES")

# Run Helm install/upgrade with the configuration
echo "Installing PATH with configuration from $([ "$USE_SECRET" = true ] && echo "Secret" || echo "ConfigMap") '$CONFIG_NAME'..."
echo "Running: ${HELM_CMD[*]}"
"${HELM_CMD[@]}"

# Check if Helm command succeeded
if [ $? -ne 0 ]; then
  echo "Error: PATH installation failed!"
  rm "$TEMP_VALUES"
  exit 1
fi

# Clean up temporary file
rm "$TEMP_VALUES"

echo "PATH installation completed successfully!"
echo "Configuration from '$CONFIG_FILE' has been stored in a Kubernetes $([ "$USE_SECRET" = true ] && echo "Secret" || echo "ConfigMap")"
echo "and is mounted at /app/config/.config.yaml in the PATH container."
