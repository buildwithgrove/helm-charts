# PATH  <!-- omit in toc -->

- [Overview](#overview)
- [Prerequisites](#prerequisites)
  - [Installation Prerequisites](#installation-prerequisites)
  - [Configuration Prerequisites](#configuration-prerequisites)
  - [Create Namespaces](#create-namespaces)
- [Configuration Requirements](#configuration-requirements)
- [Accessing PATH](#accessing-path)
- [Accessing Grafana Dashboards](#accessing-grafana-dashboards)
  - [1. Forward the Grafana port](#1-forward-the-grafana-port)
  - [2. Access Grafana in your browser](#2-access-grafana-in-your-browser)
  - [3. Log in with default credentials](#3-log-in-with-default-credentials)
  - [4. Navigate to PATH dashboards](#4-navigate-to-path-dashboards)
- [Observability Integration](#observability-integration)
- [Troubleshooting](#troubleshooting)
  - [Configuration Issues](#configuration-issues)
  - [PATH Application Issues](#path-application-issues)
  - [Observability Issues](#observability-issues)

## Overview

**PATH** (PATH API and Tooling Harness) is deployed with **WATCH** (Workload Analytics and Telemetry for Comprehensive Health)
for comprehensive monitoring, alerting, and visualization capabilities.

## Prerequisites

### Installation Prerequisites

1. [Kubernetes](https://kubernetes.io/releases/download/) 1.16+
2. [Helm](https://helm.sh/docs/helm/helm_install/) 3.1+

### Configuration Prerequisites

1. Namespace for **PATH** application (e.g., `app`)
2. Namespace for **WATCH** components (e.g., `monitoring`)

### Create Namespaces

Using `app` and `monitoring` namespaces as an examples:

```bash
kubectl create namespace app
kubectl create namespace monitoring
```

## Configuration Requirements

PATH requires a configuration file to be mounted at `/app/config/.config.yaml` in the container. This Helm chart supports two ways to provide this configuration:

1. **Using a ConfigMap**: Mount the configuration from a Kubernetes ConfigMap
2. **Using a Secret**: Mount the configuration from a Kubernetes Secret (for sensitive configuration data)

## Accessing PATH

To access the PATH, forward the HTTP port `3069`:

```bash
kubectl port-forward svc/path-http 3069:3069 -n app
```

The API will be available at `http://localhost:3069`

## Accessing Grafana Dashboards

When PATH is installed with observability enabled, you can access the Grafana dashboards to monitor your application.

### 1. Forward the Grafana port

```bash
kubectl port-forward svc/watch-grafana 3000:80 -n monitoring
```

### 2. Access Grafana in your browser

Navigate to [http://localhost:3000](http://localhost:3000) in your browser.

### 3. Log in with default credentials

- **Username**: `admin`
- **Password**: check values.yaml (default is `change-me-in-production`)

If you didn't set a custom password, retrieve it with:

```bash
kubectl get secret watch-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### 4. Navigate to PATH dashboards

- Click on Dashboards in the left sidebar
- Select the "PATH API" folder
- Choose a dashboard to view metrics for your PATH application

For more detailed instructions on accessing and troubleshooting Grafana, see the [Accessing Grafana Dashboards](path-accessing-grafana.md) guide.

## Observability Integration

**PATH** integrates with WATCH for observability, featuring:

- Prometheus for metrics collection
- Grafana for dashboards and visualization
- Pre-configured dashboards for PATH metrics
- Cross-namespace monitoring setup

For more details on the observability integration, see the [PATH-WATCH Integration Guide](path-watch-integration-guide.md).

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

Check **PATH** pod status:

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

2. Verify PATH metrics are accessible by forwarding the metrics port and curling the metrics endpoint:

   ```bash
   kubectl port-forward svc/path-metrics 9090:9090 -n app
   curl localhost:9090/metrics
   ```

3. Check if Prometheus is scraping metrics by forwarding the Prometheus port and visiting [localhost:9090/targets](http://localhost:9090/targets) in your browser:

   ```bash
   kubectl port-forward svc/watch-prometheus-server 9090:9090 -n monitoring
   ```
