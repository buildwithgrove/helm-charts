# PATH Helm Chart

![Version: 0.1.9](https://img.shields.io/badge/Version-0.1.9-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.16](https://img.shields.io/badge/AppVersion-0.0.16-informational?style=flat-square)

A Helm chart for deploying the PATH API and Tooling Harness service with integrated observability.

## Overview

PATH (PATH API and Tooling Harness) is deployed with WATCH (Workload Analytics and Telemetry for Comprehensive Health) for comprehensive monitoring, alerting, and visualization capabilities.

## Installation Prerequisites

- Kubernetes 1.16+
- Helm 3.1+
- Namespace for PATH application (e.g., `app`)
- Namespace for monitoring components (e.g., `monitoring`)

### Create Namespaces

```bash
kubectl create namespace app
kubectl create namespace monitoring
```

## Configuration Requirements

PATH requires a configuration file to be mounted at `/app/config/.config.yaml` in the container. This Helm chart supports two ways to provide this configuration:

1. **Using a ConfigMap**: Mount the configuration from a Kubernetes ConfigMap
2. **Using a Secret**: Mount the configuration from a Kubernetes Secret (for sensitive configuration data)

## Installation Options

You have multiple options for deploying PATH:

### Option 1: Using the Helper Script (Recommended for Configuration)

The provided `install-path.sh` script simplifies the process by:
1. Creating a Kubernetes ConfigMap or Secret from a local configuration file
2. Deploying the PATH Helm chart configured to use that resource

```bash
# Make the script executable
chmod +x install-path.sh

# Create a Secret from your local config file and deploy PATH (default)
./install-path.sh --config /path/to/your/.config.yaml --namespace app

# Or use a ConfigMap instead
./install-path.sh --config /path/to/your/.config.yaml --namespace app --configmap
```

#### Script Options

```
Required:
  -c, --config FILE            Path to local .config.yaml file

Options:
  -n, --namespace NAMESPACE    Kubernetes namespace (default: default)
  -r, --release-name NAME      Helm release name (default: path)
  -f, --values FILE            Custom Helm values file
  -m, --configmap              Use a ConfigMap instead of Secret (default: Secret)
  -h, --help                   Show this help message
```

### Option 2: Manual Installation

If you prefer to have more control over the installation process, you can manually create the ConfigMap or Secret and then deploy the chart.

#### Step 1: Create the ConfigMap or Secret

```bash
# Create a ConfigMap
kubectl create configmap path-config --from-file=.config.yaml=/path/to/your/.config.yaml -n app

# Or create a Secret (for sensitive data)
kubectl create secret generic path-config-secret --from-file=.config.yaml=/path/to/your/.config.yaml -n app
```

#### Step 2: Deploy PATH using Helm

```bash
# Standard installation with integrated observability
helm install path ./path --namespace app

# Using a ConfigMap for configuration
helm install path ./path \
  --namespace app \
  --set config.fromConfigMap.enabled=true \
  --set config.fromConfigMap.name=path-config

# Or using a Secret for configuration
helm install path ./path \
  --namespace app \
  --set config.fromSecret.enabled=true \
  --set config.fromSecret.name=path-config-secret

# Install without observability
helm install path ./path --namespace app --set observability.enabled=false

# Install with existing Prometheus stack
helm install path ./path --namespace app \
  --set observability.watch.kube-prometheus-stack.enabled=false \
  --set observability.watch.externalMonitoring.grafanaNamespace=monitoring
```

## Accessing PATH

To access the PATH API, forward the HTTP port:

```bash
kubectl port-forward svc/path-http 3069:3069 -n app
```

The API will be available at `http://localhost:3069`

## Accessing Grafana Dashboards

When PATH is installed with observability enabled, you can access the Grafana dashboards to monitor your application:

### 1. Forward the Grafana port

```bash
kubectl port-forward svc/watch-grafana 3000:80 -n monitoring
```

### 2. Access Grafana in your browser

Navigate to http://localhost:3000

### 3. Log in with default credentials

- **Username**: admin
- **Password**: check values.yaml (default is "change-me-in-production")

If you didn't set a custom password, retrieve it with:

```bash
kubectl get secret watch-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### 4. Navigate to PATH dashboards

- Click on Dashboards in the left sidebar
- Select the "PATH API" folder
- Choose a dashboard to view metrics for your PATH application

For more detailed instructions on accessing and troubleshooting Grafana, see the [Accessing Grafana Dashboards](accessing-grafana.md) guide.

## Configuration Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `replicas` | int | `1` | Number of PATH replicas |
| `image.repository` | string | `ghcr.io/buildwithgrove/path` | PATH Docker image repository |
| `image.tag` | string | `main` | PATH Docker image tag |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy |
| `observability.enabled` | bool | `true` | Enable WATCH observability |
| `config.fromConfigMap.enabled` | bool | `false` | Use ConfigMap for configuration |
| `config.fromConfigMap.name` | string | `path-config` | Name of the ConfigMap |
| `config.fromSecret.enabled` | bool | `false` | Use Secret for configuration |
| `config.fromSecret.name` | string | `path-config-secret` | Name of the Secret |
| `additionalManifests` | list | `[]` | Additional Kubernetes manifests |
| `additionalYamlManifests` | string | `""` | Additional YAML manifests |
| `path.resources` | object | `{}` | Resource limits and requests |
| `path.horizontalPodAutoscaler.enabled` | bool | `false` | Enable HPA |
| `path.additionalLabels` | object | `{}` | Additional labels |
| `path.additionalAnnotations` | object | `{}` | Additional annotations |

## Observability Integration

PATH integrates with WATCH for observability, featuring:

- Prometheus for metrics collection
- Grafana for dashboards and visualization
- Pre-configured dashboards for PATH metrics
- Cross-namespace monitoring setup

For more details on the observability integration, see the [PATH-WATCH Integration Guide](path-watch-integration.md).

## Troubleshooting

### Configuration Issues

If PATH fails to start or doesn't behave as expected:

1. Verify your ConfigMap or Secret exists and contains the correct configuration:
   ```bash
   kubectl get configmap path-config -n app
   kubectl describe configmap path-config -n app
   ```

2. Check the PATH logs for any configuration-related errors:
   ```bash
   kubectl logs deployment/path -n app
   ```

3. Verify the configuration is properly mounted:
   ```bash
   kubectl exec -it deployment/path -n app -- cat /app/config/.config.yaml
   ```

### PATH Application Issues

Check PATH pod status:
```bash
kubectl get pods -n app
kubectl describe pod <pod-name> -n app
kubectl logs <pod-name> -n app
```

### Observability Issues

If metrics aren't showing up in Grafana:

1. Check if ServiceMonitor exists:
   ```bash
   kubectl get servicemonitor -n monitoring | grep path
   ```

2. Verify PATH metrics are accessible:
   ```bash
   # Forward the metrics port
   kubectl port-forward svc/path-metrics 9090:9090 -n app
   # In another terminal, check metrics
   curl localhost:9090/metrics
   ```

3. Check if Prometheus is scraping metrics:
   ```bash
   # Forward Prometheus port
   kubectl port-forward svc/watch-prometheus-server 9090:9090 -n monitoring
   # Access http://localhost:9090/targets in your browser
   ```

## Further Documentation

- [PATH-WATCH Integration Guide](path-watch-integration.md)
- [Accessing Grafana Dashboards](accessing-grafana.md)
- [Namespace Considerations](namespace-considerations.md)

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
