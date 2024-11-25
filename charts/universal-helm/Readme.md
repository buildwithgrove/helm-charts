# universal-helm

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Universal Helm chart

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| HebertCL |  |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalManifests | list | `[]` |  |
| additionalYamlManifests | string | `""` |  |
| deployments | object | `{}` |  |
| global.imagePullPolicy | string | `"Always"` |  |
| global.securityContext.fsGroup | int | `1001` |  |
| global.securityContext.runAsGroup | int | `1001` |  |
| global.securityContext.runAsUser | int | `1001` |  |
| global.serviceAccount.create | bool | `true` |  |
| global.serviceAccount.name | string | `"change-me"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)