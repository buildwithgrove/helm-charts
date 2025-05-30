# Accessing PATH's Grafana Dashboards <!-- omit in toc -->

This guide provides detailed instructions for accessing the Grafana dashboards deployed by the **PATH** helm chart with **WATCH** observability.

- [Understanding the Deployment Architecture](#understanding-the-deployment-architecture)
- [Accessing Grafana](#accessing-grafana)
  - [Method 1: kubectl port-forward (Recommended for Development)](#method-1-kubectl-port-forward-recommended-for-development)
    - [Step 1: Forward the Grafana port](#step-1-forward-the-grafana-port)
    - [Step 2: Access in browser](#step-2-access-in-browser)
    - [Step 3: Log in to Grafana](#step-3-log-in-to-grafana)
  - [Method 2: Kubernetes Ingress (Recommended for Production)](#method-2-kubernetes-ingress-recommended-for-production)
- [Navigating PATH Dashboards](#navigating-path-dashboards)
- [Available PATH Metrics](#available-path-metrics)
- [Customizing Dashboards](#customizing-dashboards)
- [Troubleshooting](#troubleshooting)
  - [No Data in Dashboards](#no-data-in-dashboards)
  - [Authentication Issues](#authentication-issues)
  - [Port Forwarding Issues](#port-forwarding-issues)

## Understanding the Deployment Architecture

When **PATH** is installed with observability enabled:

- **PATH** is deployed in your application namespace (default `app`)
- Monitoring components (Prometheus, Grafana) are deployed in the `monitoring` namespace
- ServiceMonitors in `monitoring` discover and scrape metrics from **PATH** in the `app` namespace

```mermaid
graph TD
    subgraph "Kubernetes Cluster"
        subgraph "app namespace"
            PATH["PATH Application"]
            PATH_SVC["PATH Service"]
            PATH_SVC -->|"exposes"| PATH
        end
        subgraph "monitoring namespace"
            subgraph "Prometheus Stack"
                PROM["Prometheus"]
                SM["ServiceMonitor"]
                SM --> PROM
            end
            subgraph "Grafana Stack"
                GRAF["Grafana"]
                DASH["Dashboards"]
                GRAF -->|"publishes"| DASH
            end
            GRAF -->|"queries"| PROM
        end
        SM -.->|"discovers & scrapes metrics"| PATH_SVC
    end
    style PATH fill:#ff9900,stroke:#ff6600,stroke-width:2px
    style PROM fill:#6666ff,stroke:#3333cc,stroke-width:2px
    style GRAF fill:#66cc66,stroke:#339933,stroke-width:2px
    style SM fill:#cc66cc,stroke:#993399,stroke-width:2px
    style DASH fill:#ffcc66,stroke:#ff9933,stroke-width:2px
```

## Accessing Grafana

### Method 1: kubectl port-forward (Recommended for Development)

#### Step 1: Forward the Grafana port

Assuming the default release name of `path`:

```bash
kubectl port-forward svc/path-grafana 3000:80
```

This command forwards your local port 3000 to the Grafana service's port 80.

#### Step 2: Access in browser

Navigate to [http://localhost:3000](http://localhost:3000) in your browser.

#### Step 3: Log in to Grafana

Use the following credentials:

- **Username**: `admin`
- **Password**: The password specified in your `values.yaml` (default is `change-me-in-production`)

If you didn't specify a custom password, retrieve it with:

```bash
kubectl get secret path-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

<!--- TODO_DOCUMENT(@HebertCL): Document how to use WATCH integrated with an already existing monitoring solution.
-->
### Method 2: Kubernetes Ingress (Recommended for Production)

For production environments, you'll likely want to set up an Ingress for Grafana.

1. Add the following to your `values.yaml`:

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

2. Install/upgrade your **PATH** chart with these values
3. Configure your DNS to point to your ingress controller
4. Access Grafana at [https://grafana.<your-domain>.com](https://grafana.your-domain.com)

## Navigating PATH Dashboards

After logging in to Grafana:

1. Click on "Dashboards" in the left sidebar (four-squares icon)

![Grafana dashboards list](./img/grafana-dashboards-list.png)

2. Click on the "PATH" folder

3. Select one of the available dashboards:

![Grafana PATH dashboards list](./img/grafana-path-dashboards.png)

<!--- TODO_DOCUMENT(@adshmh): update the list once the MVP set of dashboards are finalized.
-->
## Available PATH Metrics

The most important metrics available in the dashboards include:

- **Request Rate**: Number of requests per second
- **Error Rate**: Percentage of requests resulting in errors
- **Latency**: Response time percentiles (p50, p95, p99)
- **Resource Usage**: CPU and memory consumption
- **Concurrent Connections**: Number of active connections

## Customizing Dashboards

You can create customized dashboards for PATH:

1. Click the "+" icon in the Grafana toolbar

![Adding a new Grafana dashboard](./img/grafana-add-dashboard.png)

2. Select "Dashboard"
3. Add panels using metrics from the "Prometheus" data source
4. Use PromQL queries like:

   ```promql
   sum(rate(http_requests_total{job="path-api"}[5m])) by (path)
   ```

<!--- TODO_DOCUMENT(@adshmh): add a link to the folder URL, through the following steps:
    1. Update the WATCH Helm Chart configmap used to define PATH dashboards to assign an easy to read ID.
    2. Include the resulting dashboard URL here.
-->
5. Save your dashboard to the "PATH" folder

## Troubleshooting

### No Data in Dashboards

If dashboards show "No data".

1. Check if the PATH metrics endpoint is accessible by

   - Forwards the metrics port: and curl the metrics endpoint:

     ```bash
     kubectl port-forward svc/path-metrics 9090:9090 -n app
     ```

   - Curl the metrics endpoint:

     ```bash
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

   Then visit [localhost:9090/targets](http://localhost:9090/targets) in your browser

### Authentication Issues

If you can't log in to Grafana:

1. Reset the `admin` password:

   ```bash
   kubectl create secret generic watch-grafana-new-credentials \
     --from-literal=admin-user=admin \
     --from-literal=admin-password=REPLACE_ME_NEW_PASSWORD \
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

2. Try a different local port (e.g. `8080`):

   ```bash
   kubectl port-forward svc/watch-grafana 8080:80 -n monitoring
   ```

   Then access at [http://localhost:8080](http://localhost:8080)
