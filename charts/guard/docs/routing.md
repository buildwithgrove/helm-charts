# Routing <!-- omit in toc -->

## Quick Introduction <!-- omit in toc -->

- GUARD supports two routing methods:
  - **Subdomain-Based Routing**
  - **Header-Based Routing**
- All routing is configured in `httproute-subdomain.yaml` or `httproute-header.yaml`
- See examples below for reference

## Table of Contents <!-- omit in toc -->

- [Subdomain-Based Routing](#subdomain-based-routing)
  - [Subdomain-Based URL Examples](#subdomain-based-url-examples)
- [Header-Based Routing](#header-based-routing)
  - [Header Routing Examples](#header-routing-examples)
- [Routed Request Examples](#routed-request-examples)
  - [Subdomain Routing (curl)](#subdomain-routing-curl)
  - [Header Routing (curl)](#header-routing-curl)

---

## Subdomain-Based Routing

GUARD subdomain routing:

- Routes traffic based on the subdomain in the request URL
- Is configured in `httproute-subdomain.yaml`

Example services config:

```yaml
services:
  - serviceId: F00C
    aliases:
      - eth
      - eth-mainnet
  - serviceId: F021
    aliases:
      - polygon
```

With this config, GUARD will:

- Create routes for each `serviceId` and its `aliases`
- Set the `target-service-id` header to the canonical `serviceId`
- Forward the request to the correct backend

### Subdomain-Based URL Examples

| URL                                       | Routed Service | Header Set                |
| ----------------------------------------- | -------------- | ------------------------- |
| `https://F00C.path.example.com/v1`        | PATH (`F00C`)  | `target-service-id: F00C` |
| `https://eth.path.example.com/v1`         | PATH (`F00C`)  | `target-service-id: F00C` |
| `https://eth-mainnet.path.example.com/v1` | PATH (`F00C`)  | `target-service-id: F00C` |
| `https://polygon.path.example.com/v1`     | PATH (`F021`)  | `target-service-id: F021` |

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
| `https://path.example.com/v1` | `-H "target-service-id: F00C"`    | PATH (`F00C`)  | `target-service-id: F00C` |
| `https://path.example.com/v1` | `-H "target-service-id: eth"`     | PATH (`F00C`)  | `target-service-id: F00C` |
| `https://path.example.com/v1` | `-H "target-service-id: polygon"` | PATH (`F021`)  | `target-service-id: F021` |

---

## Routed Request Examples

### Subdomain Routing (curl)

```bash
# Route to ETH service using subdomain
curl https://eth.path.example.com/v1 \
  -H "Authorization: test_api_key" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

### Header Routing (curl)

```bash
# Route to ETH service using header
curl https://path.example.com/v1 \
  -H "Target-Service-Id: eth" \
  -H "Authorization: test_api_key" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```
