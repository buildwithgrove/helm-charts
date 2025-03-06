# guard

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

A Helm chart for deploying Envoy Gateway

## Requirements

| Repository                 | Name         | Version |
| -------------------------- | ------------ | ------- |
| oci://docker.io/envoyproxy | gateway-helm | v1.3.0  |

## Values

| Key                                                 | Type   | Default                                                                                                                                       | Description |
| --------------------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| authServer.configMap.".config.yaml"                 | string | `"auth_server_config:\n  grpc_host_port: ext-auth-pads:10002\n  grpc_use_insecure_credentials: true\n  endpoint_id_extractor_type: header\n"` |             |
| authServer.enabled                                  | bool   | `true`                                                                                                                                        |             |
| authServer.port                                     | int    | `10001`                                                                                                                                       |             |
| authServer.replicas                                 | int    | `1`                                                                                                                                           |             |
| authServer.volumeMounts[0].mountPath                | string | `"/app/config/.config.yaml"`                                                                                                                  |             |
| authServer.volumeMounts[0].name                     | string | `"config-volume"`                                                                                                                             |             |
| authServer.volumeMounts[0].subPath                  | string | `".config.yaml"`                                                                                                                              |             |
| fullnameOverride                                    | string | `"guard"`                                                                                                                                     |             |
| global.domain                                       | string | `"localhost"`                                                                                                                                 |             |
| global.namespace                                    | string | `"path"`                                                                                                                                      |             |
| global.port                                         | int    | `3069`                                                                                                                                        |             |
| global.serviceName                                  | string | `"path-http"`                                                                                                                                 |             |
| guard.gateway.enabled                               | bool   | `true`                                                                                                                                        |             |
| guard.gateway.port                                  | int    | `3070`                                                                                                                                        |             |
| guard.services[0].aliases[0]                        | string | `"eth"`                                                                                                                                       |             |
| guard.services[0].aliases[1]                        | string | `"eth-mainnet"`                                                                                                                               |             |
| guard.services[0].serviceId                         | string | `"F00C"`                                                                                                                                      |             |
| guard.services[1].aliases[0]                        | string | `"polygon"`                                                                                                                                   |             |
| guard.services[1].aliases[1]                        | string | `"polygon-mainnet"`                                                                                                                           |             |
| guard.services[1].serviceId                         | string | `"F021"`                                                                                                                                      |             |
| pads.configMap.".gateway-endpoints.yaml"            | string | `""`                                                                                                                                          |             |
| pads.configMap.endpoints.test_endpoint.auth.api_key | string | `"test_api_key"`                                                                                                                              |             |
| pads.enabled                                        | bool   | `true`                                                                                                                                        |             |
| pads.env[0].name                                    | string | `"YAML_FILEPATH"`                                                                                                                             |             |
| pads.env[0].value                                   | string | `".gateway-endpoints.yaml"`                                                                                                                   |             |
| pads.port                                           | int    | `10002`                                                                                                                                       |             |
| pads.replicas                                       | int    | `1`                                                                                                                                           |             |
| pads.volumeMounts[0].mountPath                      | string | `"/app/.gateway-endpoints.yaml"`                                                                                                              |             |
| pads.volumeMounts[0].name                           | string | `"endpoint-data-volume"`                                                                                                                      |             |
| pads.volumeMounts[0].subPath                        | string | `".gateway-endpoints.yaml"`                                                                                                                   |             |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
