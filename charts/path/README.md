# path

![Version: 0.1.10](https://img.shields.io/badge/Version-0.1.10-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.16](https://img.shields.io/badge/AppVersion-0.0.16-informational?style=flat-square)

A Helm chart for PATH (PATH API & Toolkit Harness)

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../guard | guard | 0.1.1 |
| file://../watch | watch | 0.1.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalManifests | list | `[]` |  |
| additionalYamlManifests | string | `""` |  |
| config.fromConfigMap.enabled | bool | `false` |  |
| config.fromSecret.enabled | bool | `false` |  |
| fullnameOverride | string | `"path"` |  |
| global.imagePullPolicy | string | `"IfNotPresent"` |  |
| global.securityContext.fsGroup | int | `1001` |  |
| global.securityContext.runAsGroup | int | `1001` |  |
| global.securityContext.runAsUser | int | `1001` |  |
| global.serviceAccount.create | bool | `true` |  |
| global.serviceAccount.name | string | `"path-sa"` |  |
| guard.auth | object | `{"apiKey":{"apiKeys":["test_api_key"],"enabled":true,"headerKey":"authorization"}}` | The type of authorization flow to use. Currently supports `apiKey` and `groveLegacy`. `apiKey` is enabled by default. |
| guard.auth.apiKey | object | `{"apiKeys":["test_api_key"],"enabled":true,"headerKey":"authorization"}` | Configuration for the API key authorization flow. |
| guard.auth.apiKey.apiKeys | list | `["test_api_key"]` | An array of API keys authorized to access the PATH service. A default API key is provided for local development. IMPORTANT: For production deployments, the `apiKeys` field should be overridden with the actual API keys authorized to access the PATH service. |
| guard.auth.apiKey.enabled | bool | `true` | Whether to enable API key authentication. |
| guard.auth.apiKey.headerKey | string | `"authorization"` | The header key to use for API key authentication. |
| guard.domain | string | `"localhost"` | domain will be used for matching HTTPRoutes by subdomain, as defined in the `httproute-subdomain.yaml` template. For example, hostnames will be created for `<SERVICE_ID>.localhost`. |
| guard.fullnameOverride | string | `"guard"` |  |
| guard.gateway.enabled | bool | `true` | Whether to deploy the Envoy Gateway resource (should always be true) |
| guard.gateway.port | int | `3070` | The port that Envoy Gateway will listen on. |
| guard.global.middlewarePort | int | `3000` | The port that the Middleware service runs on in the cluster. This is the port that Envoy Gateway will forward requests to. |
| guard.global.middlewareServiceName | string | `"middleware-http"` | The name of the service that the Middleware service is deployed to. |
| guard.global.port | int | `3069` | The port that the PATH service runs on in the cluster. This is the port that Envoy Gateway will forward requests to. |
| guard.global.serviceName | string | `"path-http"` | The name of the service that the PATH service is deployed to. |
| guard.services | list | `[]` | List of services that will be routed by Envoy Gateway to the PATH backend. These services will be used to construct HTTPRoutes for each service. All services enabled for a PATH deployment must be listed here. |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"ghcr.io/buildwithgrove/path"` |  |
| image.tag | string | `"main"` |  |
| logs.format | string | `"plain"` |  |
| logs.level | string | `"info"` |  |
| nameOverride | string | `"path"` |  |
| observability.enabled | bool | `true` |  |
| observability.watch.appServiceDetails.name | string | `"{{ .Release.Name }}-metrics"` |  |
| observability.watch.appServiceDetails.namespace | string | `"{{ .Release.Namespace }}"` |  |
| observability.watch.appServiceDetails.port | string | `"metrics"` |  |
| observability.watch.dashboards.guard.enabled | bool | `false` |  |
| observability.watch.dashboards.namespace | string | `"monitoring"` |  |
| observability.watch.dashboards.path.enabled | bool | `true` |  |
| observability.watch.dashboards.path.folderName | string | `"PATH API"` |  |
| observability.watch.externalMonitoring.grafanaNamespace | string | `"monitoring"` |  |
| observability.watch.externalMonitoring.prometheusSelectorLabels."app.kubernetes.io/part-of" | string | `"watch-monitoring"` |  |
| observability.watch.serviceMonitors.guard.enabled | bool | `false` |  |
| observability.watch.serviceMonitors.namespace | string | `"monitoring"` |  |
| observability.watch.serviceMonitors.path.enabled | bool | `true` |  |
| observability.watch.serviceMonitors.path.endpoints[0].interval | string | `"15s"` |  |
| observability.watch.serviceMonitors.path.endpoints[0].path | string | `"/metrics"` |  |
| observability.watch.serviceMonitors.path.endpoints[0].port | string | `"metrics"` |  |
| observability.watch.serviceMonitors.path.selector.matchLabels."app.kubernetes.io/name" | string | `"path"` |  |
| path.additionalAnnotations | object | `{}` |  |
| path.additionalLabels | object | `{}` |  |
| path.livenessProbe.failureThreshold | int | `600` |  |
| path.livenessProbe.httpGet.path | string | `"/healthz"` |  |
| path.livenessProbe.httpGet.port | int | `3069` |  |
| path.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| path.ports[0].name | string | `"http"` |  |
| path.ports[0].port | int | `3069` |  |
| path.ports[0].protocol | string | `"TCP"` |  |
| path.ports[0].service.type | string | `"ClusterIP"` |  |
| path.ports[1].name | string | `"metrics"` |  |
| path.ports[1].port | int | `9090` |  |
| path.ports[1].protocol | string | `"TCP"` |  |
| path.ports[1].service.type | string | `"ClusterIP"` |  |
| path.readinessProbe.failureThreshold | int | `600` |  |
| path.readinessProbe.httpGet.path | string | `"/healthz"` |  |
| path.readinessProbe.httpGet.port | int | `3069` |  |
| path.readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| path.replicas | int | `1` |  |
| path.resources.limits.cpu | int | `4` |  |
| path.resources.limits.memory | string | `"2G"` |  |
| path.resources.requests.cpu | float | `1.8` |  |
| path.resources.requests.memory | string | `"800Mi"` |  |
| replicas | int | `1` |  |

