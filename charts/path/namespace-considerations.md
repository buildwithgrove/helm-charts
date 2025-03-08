# Namespace Considerations for PATH and WATCH Integration

This document provides important information about the namespace configuration when deploying PATH with WATCH observability.

## Separation of Application and Monitoring

The PATH application and WATCH monitoring components are designed to be deployed in separate namespaces:

1. **PATH Application**: Deployed in your application namespace (e.g., `app` or `default`)
2. **WATCH Components**: Deployed in the monitoring namespace (`monitoring`)

This separation follows Kubernetes best practices for isolating concerns and managing resources.

## Cross-Namespace Service Discovery

For WATCH to monitor PATH across namespaces:

1. **ServiceMonitor Configuration**: ServiceMonitors in the monitoring namespace can discover services in other namespaces.

2. **NetworkPolicy Considerations**: If you use NetworkPolicies, ensure the monitoring namespace can access metrics endpoints in the application namespace.

## Example Deployment

```bash
# Create namespaces
kubectl create namespace app
kubectl create namespace monitoring

# Deploy PATH with WATCH
helm install path ./path --namespace app
```

This will:
- Deploy PATH components in the `app` namespace
- Deploy kube-prometheus-stack components in the `monitoring` namespace
- Configure ServiceMonitors in `monitoring` to discover PATH services

## Common Issues

1. **Cross-Namespace Service Discovery Failures**:
   - Check that namespaceSelector is properly configured in ServiceMonitors
   - Verify PATH services have the expected labels

2. **Permission Issues**:
   - Ensure Prometheus has permissions to scrape metrics from the application namespace
   - Check RBAC settings if using ClusterRole-based permissions

3. **Network Connectivity**:
   - Verify there are no NetworkPolicies blocking access between namespaces
   - Check that services are accessible across namespace boundaries

## RBAC Configuration

If you're using strict RBAC policies, you may need to create a specific role for Prometheus to scrape metrics from other namespaces:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus-k8s
rules:
- apiGroups: [""]
  resources: ["services", "endpoints", "pods"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus-k8s
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus-k8s
subjects:
- kind: ServiceAccount
  name: prometheus-k8s
  namespace: monitoring
```
