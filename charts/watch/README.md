# watch

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Workload Analytics and Telemetry for Comprehensive Health - Observability stack for PATH API service

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://prometheus-community.github.io/helm-charts | kube-prometheus-stack | 69.6.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| dashboards.custom.dashboards | object | `{}` |  |
| dashboards.custom.enabled | bool | `false` |  |
| dashboards.enabled | bool | `true` |  |
| dashboards.guard.enabled | bool | `true` |  |
| dashboards.guard.folderName | string | `"GUARD API"` |  |
| dashboards.label | string | `"grafana_dashboard"` |  |
| dashboards.namespace | string | `"monitoring"` |  |
| dashboards.path.enabled | bool | `true` |  |
| dashboards.path.folderName | string | `"PATH API"` |  |
| externalMonitoring.dashboardsConfigMapLabel | string | `"grafana_dashboard"` |  |
| externalMonitoring.grafanaNamespace | string | `"monitoring"` |  |
| externalMonitoring.prometheusSelectorLabels."app.kubernetes.io/part-of" | string | `"watch-monitoring"` |  |
| global.labels.app | string | `"watch"` |  |
| global.namespace | string | `"monitoring"` |  |
| kube-prometheus-stack.enabled | bool | `true` |  |
| kube-prometheus-stack.grafana."grafana.ini"."auth.anonymous".enabled | bool | `false` |  |
| kube-prometheus-stack.grafana."grafana.ini"."auth.anonymous".org_role | string | `"Viewer"` |  |
| kube-prometheus-stack.grafana."grafana.ini".auth.disable_login_form | bool | `false` |  |
| kube-prometheus-stack.grafana."grafana.ini".security.allow_sign_up | bool | `false` |  |
| kube-prometheus-stack.grafana.adminPassword | string | `"admin"` |  |
| kube-prometheus-stack.grafana.env.GF_AUTH_BASIC_ENABLED | string | `"true"` |  |
| kube-prometheus-stack.grafana.env.GF_SECURITY_ADMIN_USER | string | `"admin"` |  |
| kube-prometheus-stack.grafana.env.GF_USERS_ALLOW_SIGN_UP | string | `"false"` |  |
| kube-prometheus-stack.grafana.env.GF_USERS_EDITORS_CAN_ADMIN | string | `"false"` |  |
| kube-prometheus-stack.grafana.env.GF_USERS_VIEWERS_CAN_EDIT | string | `"false"` |  |
| kube-prometheus-stack.grafana.persistence.enabled | bool | `true` |  |
| kube-prometheus-stack.grafana.persistence.size | string | `"5Gi"` |  |
| kube-prometheus-stack.grafana.sidecar.dashboards.enabled | bool | `true` |  |
| kube-prometheus-stack.grafana.sidecar.dashboards.folderAnnotation | string | `"grafana_folder"` |  |
| kube-prometheus-stack.grafana.sidecar.dashboards.label | string | `"grafana_dashboard"` |  |
| kube-prometheus-stack.grafana.sidecar.dashboards.provider.foldersFromFilesStructure | bool | `true` |  |
| kube-prometheus-stack.grafana.sidecar.dashboards.searchNamespace | string | `"ALL"` |  |
| kube-prometheus-stack.grafana.sidecar.datasources.enabled | bool | `true` |  |
| kube-prometheus-stack.namespaceOverride | string | `"monitoring"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.resources.limits.cpu | int | `1` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.resources.limits.memory | string | `"1Gi"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.resources.requests.cpu | string | `"200m"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.resources.requests.memory | string | `"512Mi"` |  |
| kube-prometheus-stack.prometheus.prometheusSpec.retention | string | `"15d"` |  |
| serviceMonitors.guard.enabled | bool | `true` |  |
| serviceMonitors.guard.endpoints[0].interval | string | `"15s"` |  |
| serviceMonitors.guard.endpoints[0].path | string | `"/metrics"` |  |
| serviceMonitors.guard.endpoints[0].port | string | `"metrics"` |  |
| serviceMonitors.guard.selector.matchLabels."app.kubernetes.io/name" | string | `"guard"` |  |
| serviceMonitors.namespace | string | `"monitoring"` |  |
| serviceMonitors.path.enabled | bool | `true` |  |
| serviceMonitors.path.endpoints[0].interval | string | `"15s"` |  |
| serviceMonitors.path.endpoints[0].path | string | `"/metrics"` |  |
| serviceMonitors.path.endpoints[0].port | string | `"metrics"` |  |
| serviceMonitors.path.selector.matchLabels."app.kubernetes.io/name" | string | `"path"` |  |

