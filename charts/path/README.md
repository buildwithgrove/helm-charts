# path

![Version: 0.1.22](https://img.shields.io/badge/Version-0.1.22-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.24](https://img.shields.io/badge/AppVersion-0.0.24-informational?style=flat-square)

PATH (Path API & Toolkit Harness) is an open source framework for enabling access to a decentralized supply network. It provides various tools and libraries to streamline the integration and interaction with decentralized protocols.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalManifests | list | `[]` | List of additional Kubernetes manifests to include |
| additionalYamlManifests | string | `""` | YAML string of additional manifests to include |
| config | object | `{"fromConfigMap":{"enabled":false},"fromSecret":{"enabled":false}}` | Configuration options for PATH |
| config.fromConfigMap.enabled | bool | `false` | Whether to use an existing ConfigMap for PATH configuration |
| config.fromSecret.enabled | bool | `false` | Whether to use an existing Secret for PATH configuration |
| fullnameOverride | string | `"path"` | The full name override for the chart |
| global.imagePullPolicy | string | `"IfNotPresent"` | Image pull policy for all containers in the deployment |
| global.securityContext.fsGroup | int | `1001` | File system group for the PATH containers |
| global.securityContext.runAsGroup | int | `1001` | Group ID for running PATH containers |
| global.securityContext.runAsUser | int | `1001` | User ID for running PATH containers |
| global.serviceAccount.create | bool | `true` | Whether to create a service account |
| global.serviceAccount.name | string | `"path-sa"` | The name of the service account to use |
| guard.auth | object | `{"apiKey":{"apiKeys":["test_api_key"],"enabled":true,"headerKey":"authorization"}}` | The type of authorization flow to use. Currently supports `apiKey` and `groveLegacy`. `apiKey` is enabled by default. |
| guard.auth.apiKey | object | `{"apiKeys":["test_api_key"],"enabled":true,"headerKey":"authorization"}` | Configuration for the API key authorization flow. |
| guard.auth.apiKey.apiKeys | list | `["test_api_key"]` | An array of API keys authorized to access the PATH service. A default API key is provided for local development. IMPORTANT: For production deployments, the `apiKeys` field should be overridden with the actual API keys authorized to access the PATH service. |
| guard.auth.apiKey.enabled | bool | `true` | Whether to enable API key authentication. |
| guard.auth.apiKey.headerKey | string | `"authorization"` | The header key to use for API key authentication. |
| guard.domain | string | `"localhost"` | Domain will be used for matching HTTPRoutes by subdomain, as defined in the `httproute-subdomain.yaml` template. For example, hostnames will be created for `<SERVICE_ID>.localhost`. |
| guard.enabled | bool | `false` | Whether to enable GUARD component with PATH |
| guard.fullnameOverride | string | `"guard"` | The full name override for the GUARD component |
| guard.gateway.port | int | `3070` | The port that Envoy Gateway will listen on. |
| guard.global.middlewarePort | int | `3000` | The port that the Middleware service runs on in the cluster. This is the port that Envoy Gateway will forward requests to. |
| guard.global.middlewareServiceName | string | `"middleware-http"` | This variable must correspond to the name of the Middleware Service that is deployed in the same namespace as PATH/GUARD. |
| guard.global.port | int | `3069` | The port that the PATH service runs on in the cluster. This is the port that Envoy Gateway will forward requests to. |
| guard.global.serviceName | string | `"path-http"` | The name of the service that the PATH service is deployed to. |
| guard.services | list | `[{"serviceId":"anvil"},{"aliases":["eth","eth-mainnet"],"serviceId":"F00C","trafficSplitting":{"enabled":false,"weights":{"middleware":50,"path":50}}},{"aliases":["polygon","polygon-mainnet"],"serviceId":"F021","trafficSplitting":{"enabled":false,"weights":{"middleware":50,"path":50}}}]` | List of services that will be routed by Envoy Gateway to the PATH backend. These services will be used to construct HTTPRoutes for each service. All services enabled for a PATH deployment must be listed here. |
| image.pullPolicy | string | `"Always"` | Image pull policy specifically for the PATH container |
| image.repository | string | `"ghcr.io/buildwithgrove/path"` | Docker image repository for PATH |
| image.tag | string | `"main"` | Docker image tag for PATH |
| logs | object | `{"format":"plain","level":"info"}` | Log level for PATH |
| logs.format | string | `"plain"` | Log format (plain, json) |
| logs.level | string | `"info"` | Log level (info, debug, warn, error) |
| nameOverride | string | `"path"` | The name override for the chart |
| observability.enabled | bool | `true` | Whether to enable the integrated observability stack (WATCH) |
| observability.watch.appServiceDetails.name | string | `"{{ .Release.Name }}-metrics"` | Name of the metrics service for monitoring |
| observability.watch.appServiceDetails.namespace | string | `"{{ .Release.Namespace }}"` | Namespace where the metrics service is deployed |
| observability.watch.appServiceDetails.port | string | `"metrics"` | Port name for the metrics service |
| observability.watch.dashboards.guard.enabled | bool | `false` | Whether to enable GUARD dashboards |
| observability.watch.dashboards.namespace | string | `"monitoring"` | Namespace where dashboards will be deployed |
| observability.watch.dashboards.path.enabled | bool | `true` | Whether to enable PATH dashboards |
| observability.watch.dashboards.path.folderName | string | `"PATH"` | Folder name for PATH dashboards in Grafana |
| observability.watch.externalMonitoring.grafanaNamespace | string | `"monitoring"` | Namespace where Grafana is deployed |
| observability.watch.externalMonitoring.prometheusSelectorLabels."app.kubernetes.io/part-of" | string | `"watch-monitoring"` | Labels to select Prometheus instance |
| observability.watch.serviceMonitors.guard.enabled | bool | `false` | Whether to enable GUARD ServiceMonitor |
| observability.watch.serviceMonitors.namespace | string | `"monitoring"` | Namespace where ServiceMonitors will be deployed |
| observability.watch.serviceMonitors.path.enabled | bool | `true` | Whether to enable PATH ServiceMonitor |
| observability.watch.serviceMonitors.path.endpoints[0].interval | string | `"15s"` | Scrape interval for Prometheus |
| observability.watch.serviceMonitors.path.endpoints[0].path | string | `"/metrics"` | Path for metrics endpoint |
| observability.watch.serviceMonitors.path.endpoints[0].port | string | `"metrics"` |  |
| observability.watch.serviceMonitors.path.selector.matchLabels."app.kubernetes.io/name" | string | `"path"` | Label selector for PATH service |
| path.additionalAnnotations | object | `{}` | Additional annotations to add to PATH pods |
| path.additionalLabels | object | `{}` | Additional labels to add to PATH pods |
| path.horizontalPodAutoscaler.enabled | bool | `false` | Whether to enable Horizontal Pod Autoscaler for PATH |
| path.livenessProbe | object | `{"failureThreshold":600,"httpGet":{"path":"/healthz","port":3069,"scheme":"HTTP"}}` | Liveness probe configuration for PATH |
| path.livenessProbe.failureThreshold | int | `600` | Number of attempts before considering the PATH pod not alive |
| path.livenessProbe.httpGet.path | string | `"/healthz"` | Path for the liveness probe |
| path.livenessProbe.httpGet.port | int | `3069` | Port for the liveness probe |
| path.livenessProbe.httpGet.scheme | string | `"HTTP"` | HTTP scheme for the liveness probe |
| path.ports | list | `[{"name":"http","port":3069,"protocol":"TCP","service":{"type":"ClusterIP"}},{"name":"metrics","port":9090,"protocol":"TCP","service":{"type":"ClusterIP"}}]` | Port configurations for PATH services |
| path.ports[0].port | int | `3069` | HTTP port number for the PATH service |
| path.ports[0].protocol | string | `"TCP"` | Protocol for the HTTP service |
| path.ports[0].service.type | string | `"ClusterIP"` | Kubernetes service type for the HTTP endpoint |
| path.ports[1].port | int | `9090` | Metrics port number for the PATH service |
| path.ports[1].protocol | string | `"TCP"` | Protocol for the metrics service |
| path.ports[1].service.type | string | `"ClusterIP"` | Kubernetes service type for the metrics endpoint |
| path.readinessProbe | object | `{"failureThreshold":600,"httpGet":{"path":"/healthz","port":3069,"scheme":"HTTP"}}` | Readiness probe configuration for PATH |
| path.readinessProbe.failureThreshold | int | `600` | Number of attempts before considering the PATH pod not ready |
| path.readinessProbe.httpGet.path | string | `"/healthz"` | Path for the readiness probe |
| path.readinessProbe.httpGet.port | int | `3069` | Port for the readiness probe |
| path.readinessProbe.httpGet.scheme | string | `"HTTP"` | HTTP scheme for the readiness probe |
| path.resources | object | `{}` | Resource limits and requests for PATH container |
| replicas | int | `1` | Number of PATH replicas to deploy |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
