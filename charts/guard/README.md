# guard

<!-- TODO_DOCUMENT(@commoddity): Add proper documentation for GUARD -->
<!-- TODO_DOCUMENT(@adshmh): Add a mermaid diagram to show clarify the relationship between the key components: Envoy Gateway, Gateway resource, GUARD service -->

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

A Helm chart for deploying GUARD (Gateway Utilities for Authentication, Routing & Defense) in production or development environments

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://docker.io/envoyproxy | gateway-helm | v1.3.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| auth.apiKey.apiKeys | list | `[]` |  |
| auth.apiKey.enabled | bool | `true` |  |
| auth.apiKey.headerKey | string | `""` |  |
| auth.groveLegacy.enabled | bool | `false` |  |
| auth.groveLegacy.pads.enabled | bool | `false` |  |
| auth.groveLegacy.peas.enabled | bool | `false` |  |
| domain | string | `""` |  |
| fullnameOverride | string | `"guard"` |  |
| gateway.enabled | bool | `true` |  |
| gateway.port | int | `3070` |  |
| global.middlewarePort | int | `3000` |  |
| global.middlewareServiceName | string | `"middleware-http"` |  |
| global.port | int | `3069` |  |
| global.serviceName | string | `"path-http"` |  |
| services | list | `[]` |  |

