# Namespace and Access Control Considerations for PATH and WATCH Integration <!-- omit in toc -->

This document provides important information about the namespace configuration and access control when deploying **PATH** with **WATCH** observability.

- [Separation of Application and Monitoring](#separation-of-application-and-monitoring)
- [Cross-Namespace Service Discovery](#cross-namespace-service-discovery)
- [Example Deployment](#example-deployment)
- [Common Issues](#common-issues)
- [Access Control (RBAC) Configuration](#access-control-rbac-configuration)

## Separation of Application and Monitoring

The **PATH** application and **WATCH** monitoring components are designed to be deployed in separate namespaces:

1. **PATH Application**: Deployed in your application namespace (e.g., `app` or `default`)
2. **WATCH Components**: Deployed in the monitoring namespace (`monitoring`)

This separation follows Kubernetes best practices for isolating concerns and managing resources.

## Cross-Namespace Service Discovery

For **WATCH** to monitor **PATH** across namespaces:

1. **ServiceMonitor Configuration**: ServiceMonitors in the monitoring namespace can discover services in other namespaces.
2. **NetworkPolicy Considerations**: If you use NetworkPolicies, ensure the monitoring namespace can access metrics endpoints in the application namespace.

## Example Deployment

Create the `app` and `monitoring` namespaces respectively:

```bash
kubectl create namespace app
kubectl create namespace monitoring
```

Deploy **PATH** with **WATCH**:

```bash
helm install path ./path-stack --namespace app
```

This will:

- Deploy PATH + GUARD components in the `app` namespace
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

## Access Control (RBAC) Configuration

**What is RBAC?** Role-Based Access Control (RBAC) in Kubernetes is a security mechanism that regulates which users or services can perform specific actions on resources. For monitoring across namespaces, proper RBAC configuration is essential to allow the monitoring tools to access metrics from applications in different namespaces. For more detailed information, refer to the [official Kubernetes RBAC documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

If you're using strict RBAC policies, you need to create a specific role for Prometheus to scrape metrics from other namespaces:

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

This RBAC configuration:
1. Creates a **ClusterRole** defining what resources can be accessed (services, endpoints, and pods) and what actions can be performed on them (get, list, watch)
2. Creates a **ClusterRoleBinding** that gives these permissions to the Prometheus service account in the monitoring namespace
3. Enables Prometheus to discover and scrape metrics from applications in any namespace, including the `app` namespace where PATH is deployed
