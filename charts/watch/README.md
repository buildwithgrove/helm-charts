# WATCH - Workload Analytics and Telemetry for Comprehensive Health

A Helm chart for deploying a complete observability stack for monitoring PATH and GUARD services, providing comprehensive monitoring, alerting, and visualization capabilities.

## Overview

WATCH (Workload Analytics and Telemetry for Comprehensive Health) is the observability component of the ecosystem. It complements:

- **PATH** (PATH API and Tooling Harness) - The core API service
- **GUARD** (Gateway Utilities for Authentication, Rate limiting, and Defense) - The authentication and security component

WATCH directly monitors both PATH and GUARD, providing comprehensive visibility across the entire platform.

Together, these components form a complete, secure, and observable service platform:

```mermaid
graph TD
    WATCH["WATCH (Observability)"]
    PATH["PATH (Service)"]
    GUARD["GUARD (Security)"]
    
    GUARD -->|guards| PATH
    WATCH -->|monitors| PATH
    WATCH -->|monitors| GUARD
```

This chart deploys:

- **Prometheus** (via kube-prometheus-stack): For collecting and storing metrics
- **Grafana**: For visualizing metrics with pre-configured dashboards
- **AlertManager**: For handling and routing alerts
- **Dashboard ConfigMaps**: Separate dashboard sets for PATH and GUARD components
- **ServiceMonitors**: Separate ServiceMonitors for PATH and GUARD metrics

For a detailed architecture overview, see the [Architecture Documentation](architecture.md).

## Prerequisites

- Kubernetes 1.16+ 
- Helm 3.1+
- PersistentVolume provisioner support (for Prometheus and Grafana persistence)

## Installation

### Add Required Helm Repositories

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### Install the Chart

```bash
# For standalone installation
helm install watch ./watch -n monitoring

# As part of PATH chart (recommended)
helm install path ./path --set observability.enabled=true
```

### Accessing Grafana

Once deployed, you can access Grafana using kubectl port-forward:

```bash
kubectl port-forward svc/watch-grafana 3000:80 -n monitoring
```

Then access Grafana in your browser at http://localhost:3000

## Authentication

### Admin Login

By default, Grafana is configured with the following admin credentials:
- Username: `admin`
- Password: `admin` (specified in `values.yaml`)

To update the admin password, modify the `kube-prometheus-stack.grafana.adminPassword` value in your custom values file:

```yaml
kube-prometheus-stack:
  grafana:
    adminPassword: "your-secure-password"
```

To retrieve the current admin password from a running deployment:

```bash
kubectl get secret -n monitoring watch-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### Viewer Access

To configure a viewer account with read-only access:

1. Add the following to your values file:

```yaml
kube-prometheus-stack:
  grafana:
    # Keep your admin password
    adminPassword: "your-secure-password"
    # Add users configuration
    grafana.ini:
      security:
        allow_sign_up: false
      auth:
        disable_login_form: false
      auth.anonymous:
        enabled: false
    # Create viewer user
    additionalDataSources: []
    env:
      GF_SECURITY_ADMIN_USER: admin
      GF_SECURITY_ADMIN_PASSWORD: "your-secure-password"
      GF_AUTH_BASIC_ENABLED: "true"
      GF_USERS_VIEWERS_CAN_EDIT: "false"
      GF_USERS_EDITORS_CAN_ADMIN: "false"
      GF_USERS_ALLOW_SIGN_UP: "false"
    # Add a post-start script to create a viewer user
    extraInitContainers:
      - name: setup-viewer-user
        image: "curlimages/curl:7.73.0"
        command: ["/bin/sh", "-c"]
        args:
          - |
            # Wait for Grafana to start
            sleep 30
            # Create API key for admin operations
            ADMIN_KEY=$(curl -s -X POST -H "Content-Type: application/json" -d '{"name":"admin-key","role":"Admin"}' http://admin:${GF_SECURITY_ADMIN_PASSWORD}@localhost:3000/api/auth/keys | jq -r '.key')
            # Create viewer user
            curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${ADMIN_KEY}" -d '{"name":"viewer","email":"viewer@example.com","login":"viewer","password":"viewer-password","OrgId":1,"role":"Viewer"}' http://localhost:3000/api/admin/users
```

2. Apply your configuration:

```bash
helm upgrade --install watch ./watch -n monitoring -f my-values.yaml
```

3. The viewer can now log in with:
   - Username: `viewer`
   - Password: `viewer-password`

### Anonymous Access (No Login Required)

If you prefer to disable login completely and allow anonymous access with viewer permissions:

```yaml
kube-prometheus-stack:
  grafana:
    grafana.ini:
      auth:
        disable_login_form: true
      auth.anonymous:
        enabled: true
        org_role: Viewer
```

## Configuration

See `values.yaml` for detailed configuration options. Key parameters include:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.namespace` | Default namespace for all resources | `monitoring` |
| `kube-prometheus-stack.enabled` | Enable kube-prometheus-stack installation | `true` |
| `kube-prometheus-stack.namespaceOverride` | Override namespace for kube-prometheus-stack | `monitoring` |
| `kube-prometheus-stack.prometheus.retention` | Data retention period | `15d` |
| `kube-prometheus-stack.grafana.enabled` | Enable Grafana installation | `true` |
| `kube-prometheus-stack.grafana.adminPassword` | Grafana admin password | `change-me-in-production` |
| `dashboards.enabled` | Enable all dashboard ConfigMaps | `true` |
| `dashboards.namespace` | Namespace for dashboard ConfigMaps | `monitoring` |
| `dashboards.path.enabled` | Enable PATH dashboard ConfigMaps | `true` |
| `dashboards.guard.enabled` | Enable GUARD dashboard ConfigMaps | `true` |
| `serviceMonitors.namespace` | Namespace for ServiceMonitors | `monitoring` |
| `serviceMonitors.path.enabled` | Enable ServiceMonitor for PATH | `true` |
| `serviceMonitors.guard.enabled` | Enable ServiceMonitor for GUARD | `true` |

## Deployment Options

WATCH supports multiple deployment patterns:

### 1. Full Stack

Deploy complete observability with kube-prometheus-stack:

```bash
helm install watch ./watch
```

### 2. Dashboards with Existing Infrastructure

Use WATCH dashboards with your existing monitoring:

```bash
helm install watch ./watch \
  --set kube-prometheus-stack.enabled=false \
  --set externalMonitoring.grafanaNamespace=monitoring
```

### 3. Component-Specific Monitoring

Enable or disable monitoring for specific components:

```bash
# Enable only PATH monitoring, disable GUARD
helm install watch ./watch \
  --set dashboards.guard.enabled=false \
  --set serviceMonitors.guard.enabled=false

# Enable only GUARD monitoring, disable PATH
helm install watch ./watch \
  --set dashboards.path.enabled=false \
  --set serviceMonitors.path.enabled=false
```

## Available Dashboards

The chart includes these pre-configured dashboards organized by component:

### PATH Dashboards
- **Overview**: Request rates, latencies, and resource utilization
- **Errors**: Error rates and details by endpoint
- **Performance**: Detailed performance metrics and resource usage

### GUARD Dashboards
- **Overview**: Authentication request rates and overall health
- **Errors**: Authorization/authentication failures and error patterns
- **Auth Metrics**: Detailed authentication and authorization metrics

Dashboard categories include:
1. **Service Health** - Overall uptime, response times, and availability
2. **Performance Metrics** - Request rates, latencies, and resource utilization
3. **Error Analysis** - Error rates, types, and debugging information
4. **Resource Usage** - CPU, memory, and network utilization
5. **User Activity** - Request patterns and user behavior analytics

## Adding Custom Dashboards

WATCH uses a structured approach for organizing dashboards by component:

1. Dashboard JSON files are stored in component-specific directories:
   - `dashboards/path/` for PATH dashboards
   - `dashboards/guard/` for GUARD dashboards

2. ConfigMap templates automatically load dashboards from their respective directories:
   - `templates/dashboards-path.yaml` for PATH dashboards
   - `templates/dashboards-guard.yaml` for GUARD dashboards

For detailed instructions on adding new dashboards, see the [Dashboard Implementation Guide](dashboard-implementation-guide.md).

### Adding Custom Dashboards via Helm Values

You can also provide custom dashboards directly in your values:

```yaml
dashboards:
  custom:
    enabled: true
    dashboards:
      my-dashboard:
        folderName: "Custom"
        json: |
          {
            "title": "My Custom Dashboard",
            "panels": [...]
          }
```

## Extending WATCH

WATCH is designed to be extensible:

1. **Custom Dashboards** - Add your own Grafana dashboards
2. **Alert Rules** - Define custom alerting rules
3. **Additional Data Sources** - Integrate with other monitoring systems
4. **Exporters** - Add specialized metrics exporters for additional visibility
5. **New Components** - Add monitoring for new services following the same pattern

See the [Dashboard Implementation Guide](dashboard-implementation-guide.md) for instructions on adding monitoring for new components.

## Uninstalling

```bash
helm uninstall watch -n monitoring
```

**Note:** PersistentVolumeClaims are not automatically deleted. To reclaim storage:

```bash
kubectl delete pvc -l app.kubernetes.io/instance=watch -n monitoring
```

## Security Considerations

For production deployments:
1. Change the default Grafana admin password
2. Configure TLS for all components
3. Set up proper RBAC for accessing metrics
4. Review Prometheus resource limits for your environment

## Metrics Collection

This chart assumes your services expose Prometheus-compatible metrics:
- PATH service should be labeled with `app.kubernetes.io/name: path`
- GUARD service should be labeled with `app.kubernetes.io/name: guard`
