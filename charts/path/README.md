# path

![Version: 0.1.9](https://img.shields.io/badge/Version-0.1.9-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.16](https://img.shields.io/badge/AppVersion-0.0.16-informational?style=flat-square)

A Helm chart for deploying PATH (PATH API & Toolkit Harness) in production or development environments

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../guard | guard | 0.1.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalManifests | list | `[]` |  |
| additionalYamlManifests | string | `""` |  |
| fullnameOverride | string | `"path"` |  |
| global.imagePullPolicy | string | `"IfNotPresent"` |  |
| global.securityContext.fsGroup | int | `1001` |  |
| global.securityContext.runAsGroup | int | `1001` |  |
| global.securityContext.runAsUser | int | `1001` |  |
| global.serviceAccount.create | bool | `true` |  |
| global.serviceAccount.name | string | `"path-sa"` |  |
| guard.auth.apiKey | object | `{"apiKeys":{},"enabled":true,"headerKey":"authorization"}` | enabled: Whether to enable API key authentication (default: true). |
| guard.auth.apiKey.apiKeys | object | `{}` | apiKeys: A map of API keys authorized to access the PATH service. A default API key is provided below for testing purposes.  IMPORTANT: For production deployments, the `apiKeys` field should be overridden with the actual API keys for the PATH service. |
| guard.auth.apiKey.headerKey | string | `"authorization"` | headerKey: The header key to use for API key authentication. |
| guard.domain | string | `"localhost"` | domain will be used for matching HTTPRoutes by subdomain, as defined in the `httproute-subdomain.yaml` template. For example, hostnames will be created for `<SERVICE_ID>.localhost`.  IMPORTANT: For production deployments, the `domain` field should be overridden with the actual domain name for the PATH service. |
| guard.fullnameOverride | string | `"guard"` |  |
| guard.gateway.enabled | bool | `true` | enabled: Whether to deploy the Envoy Gateway resource (should always be true) |
| guard.gateway.port | int | `3070` | port: The port that Envoy Gateway will listen on. |
| guard.global.port | int | `3069` | port is the port that the PATH service runs on in the cluster. This is the port that Envoy Gateway will forward requests to. |
| guard.global.serviceName | string | `"path-http"` | serviceName is the name of the service that the PATH service is deployed to. |
| guard.services | list | `[]` | List of services that will be routed by Envoy Gateway to the PATH backend. These services will be used to construct HTTPRoutes for each service. These HTTPRoutes are used to assign the "target-service-id" header to the request based on the subdomain service alias.  Configurations: - serviceId [REQUIRED]: The authorative service ID of the service. - aliases [OPTIONAL]: A list of aliases for the service.  For example: - anvil.localhost -> "target-service-id: anvil" - F00C.path.grove.city -> "target-service-id: F00C" - eth.path.grove.city -> "target-service-id: F00C" - polygon.path.grove.city -> "target-service-id: F021" |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/buildwithgrove/path"` |  |
| image.tag | string | `"main"` |  |
| nameOverride | string | `"path"` |  |
| path.additionalAnnotations | object | `{}` |  |
| path.additionalLabels | object | `{}` |  |
| path.livenessProbe.failureThreshold | int | `600` |  |
| path.livenessProbe.httpGet.path | string | `"/healthz"` |  |
| path.livenessProbe.httpGet.port | int | `3069` |  |
| path.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| path.mountSecrets[0].items[0].key | string | `".config.yaml"` |  |
| path.mountSecrets[0].items[0].path | string | `".config.yaml"` |  |
| path.mountSecrets[0].mountPath | string | `"/app/config/.config.yaml"` |  |
| path.mountSecrets[0].name | string | `"path-config"` |  |
| path.mountSecrets[0].subPath | string | `".config.yaml"` |  |
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

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
