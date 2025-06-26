# Routing <!-- omit in toc -->

## Quick Introduction <!-- omit in toc -->

- Routing in GUARD is handled through [Kubernetes Gateway API HTTPRoutes](https://gateway-api.sigs.k8s.io/api-types/httproute/)
- `HTTPRoute` resources are created from the `guard.services` field in [`values.yaml`](https://github.com/buildwithgrove/helm-charts/blob/main/charts/guard/values.yaml#L39) 
  - These services creates `HTTPRoutes` based on the template files:
    - [`httproute-subdomain.yaml`](https://github.com/buildwithgrove/helm-charts/blob/main/charts/guard/templates/routing/httproute-subdomain.yaml)
    - [`httproute-header.yaml`](https://github.com/buildwithgrove/helm-charts/blob/main/charts/guard/templates/routing/httproute-header.yaml)
- See examples below for reference

## Table of Contents <!-- omit in toc -->

- [Subdomain-Based Routing](#subdomain-based-routing)
  - [Subdomain-Based URL Examples](#subdomain-based-url-examples)
  - [Subdomain Routing Example Request (cURL)](#subdomain-routing-example-request-curl)
- [Header-Based Routing](#header-based-routing)
  - [Header Routing Examples](#header-routing-examples)
  - [Header Routing Example Request (cURL)](#header-routing-example-request-curl)

---

## Subdomain-Based Routing

GUARD subdomain routing:

- Routes traffic based on the subdomain in the request URL
- Is configured in `httproute-subdomain.yaml`

Example services config:

```yaml
services:
  - serviceId: eth
    aliases:
      - eth
      - eth-mainnet
  - serviceId: polygon
    aliases:
      - polygon
```

With this config, GUARD will:

- Create `HTTPRoute` resources for each `serviceId` and its `aliases`
- Set the `target-service-id` header to the canonical `serviceId`
- Forward the request to the correct backend

### Subdomain-Based URL Examples

GUARD subdomain routing:

- Routes traffic based on the subdomain in the request URL
- Is configured in `httproute-subdomain.yaml`
- Uses the same `services` config as above
- Client specifies the target service in the subdomain

| URL                                       | Routed Service | Header Set                |
| ----------------------------------------- | -------------- | ------------------------- |
| `https://eth.path.example.com/v1`         | PATH (`eth`)   | `target-service-id: eth` |
| `https://eth-mainnet.path.example.com/v1` | PATH (`eth`)   | `target-service-id: eth` |
| `https://polygon.path.example.com/v1`     | PATH (`polygon`) | `target-service-id: polygon` |

### Subdomain Routing Example Request (cURL)

```bash
# Route to ETH service using subdomain
curl https://eth.path.example.com/v1 \
  -H "Authorization: test_api_key" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

---

## Header-Based Routing

GUARD header-based routing:

- Routes traffic based on the `target-service-id` HTTP header
- Is configured in `httproute-header.yaml`
- Uses the same `services` config as above
- Client specifies the target service in the header

### Header Routing Examples

| URL                           | Header Example                    | Routed Service | Header Set                |
| ----------------------------- | --------------------------------- | -------------- | ------------------------- |
| `https://path.example.com/v1` | `-H "target-service-id: eth"`     | PATH (`eth`)   | `target-service-id: eth` |
| `https://path.example.com/v1` | `-H "target-service-id: polygon"` | PATH (`polygon`) | `target-service-id: polygon` |

### Header Routing Example Request (cURL)

```bash
# Route to ETH service using header
curl https://path.example.com/v1 \
  -H "Target-Service-Id: eth" \
  -H "Authorization: test_api_key" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```
