# Accessing PATH's Grafana Dashboards

This guide provides detailed instructions for accessing the Grafana dashboards deployed by the PATH Helm chart with WATCH observability.

## Understanding the Deployment Architecture

When PATH is installed with observability enabled:
- PATH API service is deployed in your application namespace (e.g., `app`)
- Monitoring components (Prometheus, Grafana) are deployed in the `monitoring` namespace
- ServiceMonitors in `monitoring` discover and scrape metrics from PATH in the `app` namespace

## Accessing Grafana

### Method 1: kubectl port-forward (Recommended for Development)

#### Step 1: Forward the Grafana port

Assuming the default release name of `path`:

```bash
kubectl port-forward svc/path-grafana 3000:80
```

This command forwards your local port 3000 to the Grafana service's port 80.

#### Step 2: Access in browser

Navigate to:
```
http://localhost:3000
```

#### Step 3: Log in to Grafana

Use the following credentials:
- **Username**: admin
- **Password**: The password specified in your values.yaml (default is "change-me-in-production")

If you didn't specify a custom password, retrieve it with:
```bash
kubectl get secret path-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### Method 2: Kubernetes Ingress (For Production)

For production environments, you'll likely want to set up an Ingress for Grafana:

1. Add the following to your values.yaml:
```yaml
observability:
  watch:
    kube-prometheus-stack:
      grafana:
        ingress:
          enabled: true
          hosts:
            - grafana.your-domain.com
          tls:
            - hosts:
                - grafana.your-domain.com
              secretName: grafana-tls
```

2. Install/upgrade your PATH chart with these values
3. Configure your DNS to point to your ingress controller
4. Access Grafana at https://grafana.your-domain.com

## Navigating PATH Dashboards

After logging in to Grafana:

1. Click on "Dashboards" in the left sidebar (four-squares icon)
2. Select "Browse" to see all folders
3. Click on the "PATH API" folder
4. Select one of the available dashboards:
   - **PATH API Overview**: General metrics and health
   - **PATH API Errors**: Error rates and details
   - **PATH API Performance**: Detailed performance metrics

## Available PATH Metrics

The most important metrics available in the dashboards include:

- **Request Rate**: Number of requests per second
- **Error Rate**: Percentage of requests resulting in errors
- **Latency**: Response time percentiles (p50, p95, p99)
- **Resource Usage**: CPU and memory consumption
- **Concurrent Connections**: Number of active connections

## Customizing Dashboards

You can create customized dashboards for PATH:

1. Click the "+" icon in the Grafana sidebar
2. Select "Dashboard"
3. Add panels using metrics from the "Prometheus" data source
4. Use PromQL queries like:
   ```
   sum(rate(http_requests_total{job="path-api"}[5m])) by (path)
   ```

5. Save your dashboard to the "PATH API" folder

## Troubleshooting

### No Data in Dashboards

If dashboards show "No data":

1. Check if the PATH metrics endpoint is accessible:
   ```bash
   # Forward the metrics port
   kubectl port-forward svc/path-metrics 9090:9090 -n app
   # In another terminal
   curl localhost:9090/metrics
   ```

2. Verify the ServiceMonitor is configured correctly:
   ```bash
   kubectl get servicemonitor -n monitoring | grep path
   kubectl describe servicemonitor watch-path -n monitoring
   ```

3. Check Prometheus targets:
   ```bash
   kubectl port-forward svc/watch-prometheus-server 9090:9090 -n monitoring
   ```
   Then visit http://localhost:9090/targets in your browser

### Authentication Issues

If you can't log in to Grafana:

1. Reset the admin password:
   ```bash
   kubectl create secret generic watch-grafana-new-credentials \
     --from-literal=admin-user=admin \
     --from-literal=admin-password=newpassword \
     -n monitoring --dry-run=client -o yaml | kubectl apply -f -
   
   kubectl rollout restart deployment watch-grafana -n monitoring
   ```

2. Wait for Grafana to restart, then try logging in with the new credentials

### Port Forwarding Issues

If port forwarding doesn't work:

1. Ensure the service exists:
   ```bash
   kubectl get svc -n monitoring
   ```

2. Try a different local port:
   ```bash
   kubectl port-forward svc/watch-grafana 8080:80 -n monitoring
   ```
   Then access at http://localhost:8080
