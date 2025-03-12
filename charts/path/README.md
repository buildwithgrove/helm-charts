# path

![Version: 0.1.10](https://img.shields.io/badge/Version-0.1.10-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.16](https://img.shields.io/badge/AppVersion-0.0.16-informational?style=flat-square)

A Helm chart for PATH (PATH API & Toolkit Harness)

## Requirements

| Repository                                    | Name  | Version |
| --------------------------------------------- | ----- | ------- |
| https://buildwithgrove.github.io/helm-charts/ | guard | 0.1.1   |
| https://buildwithgrove.github.io/helm-charts/ | watch | 0.1.1   |

## Values

| Key                                                                                         | Type   | Default                         | Description |
| ------------------------------------------------------------------------------------------- | ------ | ------------------------------- | ----------- |
| config.fromConfigMap.enabled                                                                | bool   | `false`                         |             |
| config.fromSecret.enabled                                                                   | bool   | `false`                         |             |
| fullnameOverride                                                                            | string | `"path"`                        |             |
| global.imagePullPolicy                                                                      | string | `"IfNotPresent"`                |             |
| global.securityContext.fsGroup                                                              | int    | `1001`                          |             |
| global.securityContext.runAsGroup                                                           | int    | `1001`                          |             |
| global.securityContext.runAsUser                                                            | int    | `1001`                          |             |
| global.serviceAccount.create                                                                | bool   | `true`                          |             |
| global.serviceAccount.name                                                                  | string | `"path-sa"`                     |             |
| image.pullPolicy                                                                            | string | `"Always"`                      |             |
| image.repository                                                                            | string | `"ghcr.io/buildwithgrove/path"` |             |
| image.tag                                                                                   | string | `"main"`                        |             |
| logs.format                                                                                 | string | `"plain"`                       |             |
| logs.level                                                                                  | string | `"info"`                        |             |
| nameOverride                                                                                | string | `"path"`                        |             |
| observability.enabled                                                                       | bool   | `true`                          |             |
| observability.watch.appServiceDetails.name                                                  | string | `"{{ .Release.Name }}-metrics"` |             |
| observability.watch.appServiceDetails.namespace                                             | string | `"{{ .Release.Namespace }}"`    |             |
| observability.watch.appServiceDetails.port                                                  | string | `"metrics"`                     |             |
| observability.watch.dashboards.guard.enabled                                                | bool   | `false`                         |             |
| observability.watch.dashboards.namespace                                                    | string | `"monitoring"`                  |             |
| observability.watch.dashboards.path.enabled                                                 | bool   | `true`                          |             |
| observability.watch.dashboards.path.folderName                                              | string | `"PATH API"`                    |             |
| observability.watch.externalMonitoring.grafanaNamespace                                     | string | `"monitoring"`                  |             |
| observability.watch.externalMonitoring.prometheusSelectorLabels."app.kubernetes.io/part-of" | string | `"watch-monitoring"`            |             |
| observability.watch.serviceMonitors.guard.enabled                                           | bool   | `false`                         |             |
| observability.watch.serviceMonitors.namespace                                               | string | `"monitoring"`                  |             |
| observability.watch.serviceMonitors.path.enabled                                            | bool   | `true`                          |             |
| observability.watch.serviceMonitors.path.endpoints[0].interval                              | string | `"15s"`                         |             |
| observability.watch.serviceMonitors.path.endpoints[0].path                                  | string | `"/metrics"`                    |             |
| observability.watch.serviceMonitors.path.endpoints[0].port                                  | string | `"metrics"`                     |             |
| observability.watch.serviceMonitors.path.selector.matchLabels."app.kubernetes.io/name"      | string | `"path"`                        |             |
| path.additionalAnnotations                                                                  | object | `{}`                            |             |
| path.additionalLabels                                                                       | object | `{}`                            |             |
| path.livenessProbe.failureThreshold                                                         | int    | `600`                           |             |
| path.livenessProbe.httpGet.path                                                             | string | `"/healthz"`                    |             |
| path.livenessProbe.httpGet.port                                                             | int    | `3069`                          |             |
| path.livenessProbe.httpGet.scheme                                                           | string | `"HTTP"`                        |             |
| path.ports[0].name                                                                          | string | `"http"`                        |             |
| path.ports[0].port                                                                          | int    | `3069`                          |             |
| path.ports[0].protocol                                                                      | string | `"TCP"`                         |             |
| path.ports[0].service.type                                                                  | string | `"ClusterIP"`                   |             |
| path.ports[1].name                                                                          | string | `"metrics"`                     |             |
| path.ports[1].port                                                                          | int    | `9090`                          |             |
| path.ports[1].protocol                                                                      | string | `"TCP"`                         |             |
| path.ports[1].service.type                                                                  | string | `"ClusterIP"`                   |             |
| path.readinessProbe.failureThreshold                                                        | int    | `600`                           |             |
| path.readinessProbe.httpGet.path                                                            | string | `"/healthz"`                    |             |
| path.readinessProbe.httpGet.port                                                            | int    | `3069`                          |             |
| path.readinessProbe.httpGet.scheme                                                          | string | `"HTTP"`                        |             |
| path.replicas                                                                               | int    | `1`                             |             |
| path.resources.limits.cpu                                                                   | int    | `4`                             |             |
| path.resources.limits.memory                                                                | string | `"2G"`                          |             |
| path.resources.requests.cpu                                                                 | float  | `1.8`                           |             |
| path.resources.requests.memory                                                              | string | `"800Mi"`                       |             |
| replicas                                                                                    | int    | `1`                             |             |
