# Accessing Grafana Dashboards <!-- omit in toc -->

This guide provides instructions for accessing the Grafana dashboards deployed by the **WATCH** Helm chart.

- [Using kubectl port-forward](#using-kubectl-port-forward)
  - [Step 1: Find the Grafana service](#step-1-find-the-grafana-service)
  - [Step 2: Set up port forwarding](#step-2-set-up-port-forwarding)
  - [Step 3: Access Grafana in your browser](#step-3-access-grafana-in-your-browser)
  - [Step 4: Log in to Grafana](#step-4-log-in-to-grafana)
- [Using continuous port forwarding (optional)](#using-continuous-port-forwarding-optional)
- [Accessing PATH Dashboards](#accessing-path-dashboards)
- [Troubleshooting](#troubleshooting)
  - [Cannot connect to Grafana](#cannot-connect-to-grafana)
  - [No data in dashboards](#no-data-in-dashboards)

## Using kubectl port-forward

The simplest way to access Grafana when it's not exposed via an Ingress is to use `kubectl port-forward`.

### Step 1: Find the Grafana service

The Grafana service is deployed with the name `watch-grafana` in the monitoring namespace:

```bash
kubectl get svc -n monitoring | grep grafana
```

You should see output similar to:

```text
watch-grafana                    ClusterIP   10.100.200.30   <none>        80/TCP                     3h
```

### Step 2: Set up port forwarding

Use the kubectl port-forward command to forward a local port to the Grafana service:

```bash
kubectl port-forward svc/watch-grafana 3000:80 -n monitoring
```

This command forwards your local port `3000` to port `80` of the Grafana service.

The command will continue running and showing output like:

```text
Forwarding from 127.0.0.1:3000 -> 3000
Forwarding from [::1]:3000 -> 3000
```

:::tip

You can change 3000 to any available port on your local machine.

:::

### Step 3: Access Grafana in your browser

While the port-forward command is running, open your web browser and navigate to [localhost:3000](http://localhost:3000).

You should see the Grafana login page.

### Step 4: Log in to Grafana

Log in with the following credentials:

- **Username**: `admin`
- **Password**: The password specified in your values.yaml (default is `change-me-in-production`)

If you didn't specify a custom password, check the values set during installation:

```bash
kubectl get secret watch-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

## Using continuous port forwarding (optional)

If you want to keep the port forwarding running in the background, you can start it as a background process:

```bash
kubectl port-forward svc/watch-grafana 3000:80 -n monitoring &
```

To later stop the port forwarding, find and kill the process

```bash
kill $(ps aux | grep "port-forward" | grep "grafana" | awk '{print $2}')
```

## Accessing PATH Dashboards

After logging in to Grafana:

1. Click on the `Dashboards` option in the left sidebar
2. Navigate to the `PATH API` folder
3. Select a dashboard to view

You should now see the metrics for your PATH application displayed in the dashboard.

## Troubleshooting

### Cannot connect to Grafana

If you can't connect to Grafana at [localhost:3000](http://localhost:3000):

1. Check if port forwarding is running:

   ```bash
   ps aux | grep "port-forward" | grep "grafana"
   ```

2. Ensure the port isn't already in use:

   ```bash
   netstat -tuln | grep 3000
   ```

3. Try a different local port:

   ```bash
   kubectl port-forward svc/watch-grafana 8080:80 -n monitoring
   ```

   And access at [localhost:8080](http://localhost:8080).

### No data in dashboards

If dashboards show "No data" or similar errors:

1. Get the prometheus pod name:

   ```bash
   PROMETHEUS_POD=$(kubectl get pods -n monitoring -l app=prometheus -o jsonpath="{.items[0].metadata.name}")
   ```

2. Access the Prometheus targets page

   ```bash
   kubectl exec -it $PROMETHEUS_POD -n monitoring -- /bin/sh

   ```

3. Visit [localhost:9090/targets](http://localhost:9090/targets) and check if the PATH targets are up. Alternatively:

   ```bash
   curl http://localhost:9090/api/v1/targets | jq
   ```

   Then

4. Verify the service monitor is configured correctly:

   ```bash
   kubectl get servicemonitor -n monitoring | grep path
   kubectl describe servicemonitor <servicemonitor-name> -n monitoring
   ```
