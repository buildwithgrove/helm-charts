# PATH Integration with WATCH (kube-prometheus-stack)

This document explains how the PATH Helm chart integrates with the WATCH chart that now uses kube-prometheus-stack for monitoring.

## Architecture

The observability architecture uses Prometheus Operator's pattern:

1. **PATH Exposes Metrics**: The PATH chart configures a service with metrics endpoint.

2. **WATCH Creates ServiceMonitors**: The WATCH chart uses ServiceMonitor CRDs to tell Prometheus which services to scrape.

3. **Prometheus Operator Handles Discovery**: The Prometheus Operator watches for ServiceMonitors and configures Prometheus to scrape the metrics endpoints.

```
┌───────────────────────────────────────┐
│                 WATCH                 │
│        (kube-prometheus-stack)        │
│                                       │
└─────┬───────────────────────────┬─────┘
      │                           │
  monitors                    monitors
      │                           │
      ▼                           ▼
┌───────────┐     guards    ┌───────────┐
│           │◀──────────────│           │
│   PATH    │               │   GUARD   │
│  (Service)│               │ (Security)│
│           │               │           │
└───────────┘               └───────────┘
```

## Usage Scenarios

### Scenario 1: Full Integrated Stack

Deploy PATH with the full WATCH stack in the monitoring namespace:

```bash
helm install path ./path --namespace app
```

This will deploy:
- PATH service in the app namespace
- WATCH with kube-prometheus-stack in the monitoring namespace
- ServiceMonitor for PATH metrics in the monitoring namespace
- Dashboards for PATH in the monitoring namespace

### Scenario 2: PATH with Existing Prometheus Stack

If you already have kube-prometheus-stack installed:

```bash
helm install path ./path --namespace app \
  --set observability.watch.kube-prometheus-stack.enabled=false \
  --set observability.watch.externalMonitoring.grafanaNamespace=monitoring
```

### Scenario 3: PATH Without Observability

If you want to deploy PATH without any observability components:

```bash
helm install path ./path --namespace app --set observability.enabled=false
```

### Scenario 4: PATH with GUARD Monitoring

If you're using both PATH and GUARD and want to monitor both:

```bash
helm install path ./path \
  --set observability.watch.dashboards.guard.enabled=true \
  --set observability.watch.serviceMonitors.guard.enabled=true
```

## Configuration

The integration is controlled by these key parameters:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `observability.enabled` | Enable the WATCH chart | `true` |
| `observability.watch.global.namespace` | Namespace for WATCH resources | `monitoring` |
| `observability.watch.kube-prometheus-stack.enabled` | Enable Prometheus stack | `true` |
| `observability.watch.kube-prometheus-stack.namespaceOverride` | Namespace for Prometheus stack | `monitoring` |
| `observability.watch.dashboards.path.enabled` | Enable PATH dashboards | `true` |
| `observability.watch.dashboards.guard.enabled` | Enable GUARD dashboards | `false` |
| `observability.watch.serviceMonitors.path.enabled` | Enable PATH ServiceMonitor | `true` |
| `observability.watch.serviceMonitors.namespace` | Namespace for ServiceMonitors | `monitoring` |

Note that `serviceMonitor.enabled` is set to `false` in the PATH chart since WATCH now handles all ServiceMonitor configurations.

## Adding Custom Dashboards

There are two approaches to add custom dashboards:

### 1. Create a Values File with Custom Dashboards

```yaml
observability:
  watch:
    dashboards:
      custom:
        enabled: true
        dashboards:
          my-dashboard:
            folderName: "PATH Custom"
            json: |
              {
                "title": "PATH Custom Dashboard",
                ...
              }
```

### 2. Create Additional ConfigMaps

After deploying, create ConfigMaps in the monitoring namespace with the proper labels:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-path-dashboard
  namespace: monitoring  # Must be in the monitoring namespace
  labels:
    grafana_dashboard: "1"
  annotations:
    grafana_folder: "PATH"
data:
  my-dashboard.json: |
    {
      "title": "My PATH Dashboard",
      ...
    }
```

For more detailed instructions on adding dashboards, refer to the WATCH chart's [Dashboard Implementation Guide](dashboard-implementation-guide.md).

## Accessing Dashboards

After deploying PATH with WATCH:

1. Get the Grafana service port:
   ```bash
   kubectl get svc -n monitoring | grep grafana
   ```

2. Forward the port to your local machine:
   ```bash
   kubectl port-forward svc/watch-grafana 3000:80 -n monitoring
   ```

3. Access Grafana at http://localhost:3000 with the default credentials:
   - Username: admin
   - Password: from values.yaml (default: "change-me-in-production")

## Troubleshooting

### ServiceMonitor Issues

If metrics aren't being collected:

1. Verify the ServiceMonitor is created in the monitoring namespace:
   ```bash
   kubectl get servicemonitors -n monitoring
   ```

2. Check if the ServiceMonitor has the correct labels:
   ```bash
   kubectl get servicemonitor <name> -n monitoring -o yaml | grep app.kubernetes.io/part-of
   ```

3. Check if PATH metrics service is accessible from the monitoring namespace:
   ```bash
   # From a pod in the monitoring namespace
   curl path-metrics.app.svc.cluster.local:9090/metrics
   ```

### Dashboard Issues

If dashboards aren't appearing:

1. Check if the ConfigMaps were created:
   ```bash
   kubectl get configmaps -n <namespace> | grep dashboard
   ```

2. Verify Grafana sidecar logs:
   ```bash
   kubectl logs -n <namespace> deployment/<release-name>-grafana -c sidecar
   ```

For more troubleshooting help, refer to the WATCH chart's documentation.
