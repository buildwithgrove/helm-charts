#!/usr/bin/env bash
set -euo pipefail

# Script to validate Helm chart dependencies

# Function to output error messages
error() {
  echo "ERROR: $*" >&2
}

# Function to output info messages
info() {
  echo "INFO: $*"
}

# Validate a single dependency
validate_dependency() {
  local name=$1
  local version=$2
  local repo=$3
  local chart_name=$4

  info "Validating $chart_name dependency: $name version $version from $repo"
  
  # Skip validation for local dependencies
  if [[ "$repo" == "file://"* ]]; then
    info "Skipping local dependency: $name"
    return 0
  fi
  
  # Perform the search
  local search_output
  search_output=$(helm search repo "$name" --version="$version" -o json)
  
  # Check if the result is an empty array
  if [[ "$search_output" == "[]" ]]; then
    error "Dependency validation failed: $name version $version not found"
    return 1
  else
    info "Dependency validation passed: $name version $version found"
    return 0
  fi
}

# Process a single chart
process_chart() {
  local chart_dir=$1
  local chart_name=$(basename "$chart_dir")
  
  info "Processing chart: $chart_name"
  
  # Check if Chart.yaml exists
  if [[ ! -f "${chart_dir}/Chart.yaml" ]]; then
    info "Chart.yaml not found for $chart_name"
    return 0
  fi
  
  # Parse dependencies from Chart.yaml
  # This uses a simple grep pattern that should be reliable
  local deps_section
  deps_section=$(grep -A100 "^dependencies:" "${chart_dir}/Chart.yaml" || echo "")
  
  if [[ -z "$deps_section" ]]; then
    info "No dependencies section found for chart $chart_name"
    return 0
  fi
  
  # Process each dependency
  local current_name=""
  local current_version=""
  local current_repo=""
  local validation_failed=0
  
  while IFS= read -r line; do
    # Skip if we've reached the end of the dependencies section
    if [[ "$line" =~ ^[a-zA-Z] ]] && [[ ! "$line" =~ ^dependencies: ]]; then
      break
    fi
    
    # Parse name, version, repository
    if [[ "$line" =~ name:[[:space:]]*(.*) ]]; then
      current_name="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ version:[[:space:]]*(.*) ]]; then
      current_version="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ repository:[[:space:]]*(.*) ]]; then
      current_repo="${BASH_REMATCH[1]}"
      
      # If we have all three pieces, validate this dependency
      if [[ -n "$current_name" && -n "$current_version" && -n "$current_repo" ]]; then
        if ! validate_dependency "$current_name" "$current_version" "$current_repo" "$chart_name"; then
          validation_failed=1
          echo "FAILED: $chart_name dependency $current_name:$current_version"
        fi
        
        # Reset for next dependency
        current_name=""
        current_version=""
        current_repo=""
      fi
    fi
  done < <(echo "$deps_section")
  
  return $validation_failed
}

# Main execution

# Ensure repositories are updated
info "Updating Helm repositories"
helm repo update

# Process all charts
validation_failed=0

for chart_dir in charts/*/; do
  if ! process_chart "$chart_dir"; then
    validation_failed=1
  fi
done

if [[ $validation_failed -eq 1 ]]; then
  error "Chart dependency validation FAILED"
  exit 1
else
  info "All chart dependencies validated successfully"
  exit 0
fi