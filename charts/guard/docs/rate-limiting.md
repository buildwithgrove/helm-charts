# Rate Limiting <!-- omit in toc -->

## Quick Start <!-- omit in toc -->

Enable rate limiting by default in `values.yaml`:

```yaml
rateLimit:
  enabled: true
  redis:
    enabled: true
  plans:
    - header: "Rl-Plan-Free"
      requests: 150000
      unit: Month
```

To test, send a request like:

```bash
curl http://rpc.grove.city/v1 \
  -H "Rl-Plan-Free: 1a2b3c4d" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","id":1}'
```

## Table of Contents <!-- omit in toc -->

- [Introduction](#introduction)
- [How Rate Limiting Works](#how-rate-limiting-works)
- [Header-Based Rate Limiting](#header-based-rate-limiting)
  - [Example Rate-Limited Request](#example-rate-limited-request)
  - [Rate Limit Response Headers](#rate-limit-response-headers)
  - [Setting Header Values](#setting-header-values)
- [Rate Limiting Configuration](#rate-limiting-configuration)
  - [Default Configuration](#default-configuration)
  - [Adding New Rate Limit Plans](#adding-new-rate-limit-plans)
  - [Multiple Rate Limits per Plan](#multiple-rate-limits-per-plan)
  - [Redis Configuration](#redis-configuration)
    - [Using External Redis](#using-external-redis)
- [Gateway Helm Configuration](#gateway-helm-configuration)
  - [Enabling X-RateLimit Headers](#enabling-x-ratelimit-headers)
- [Common Tasks](#common-tasks)
- [Documentation References](#documentation-references)

## Introduction

A few quick notes to get you started:

- GUARD uses Envoy Gateway's Global Rate Limiting.
- Rate Limiting is configured in [`values.yaml`](https://github.com/buildwithgrove/helm-charts/blob/main/charts/guard/values.yaml).
- Redis is used as the backend for rate limiting.

## How Rate Limiting Works

- Rate limits are based on unique HTTP header values.
- Each unique header value = separate rate limit bucket.
- Example: `Rl-Plan-Free: 1a2b3c4d` and `Rl-Plan-Free: 9z8y7x6w` are tracked separately.

## Header-Based Rate Limiting

| Header Value   | Requests | Unit   | Example User ID |
| -------------- | -------- | ------ | --------------- |
| `Rl-Plan-Free` | `150000` | Month  | `1a2b3c4d`      |
| `Rl-Plan-Free` | `30`     | Second | `1a2b3c4d`      |
| `Rl-Plan-Pro`  | `5000`   | Day    | `5e6f7g8h`      |

- Each distinct user ID in the header gets its own rate bucket.
- Example: `Rl-Plan-Free: 1a2b3c4d` is limited to 150000/month and 30/second.

### Example Rate-Limited Request

```bash
curl http://rpc.grove.city/v1 \
  -H "Rl-Plan-Free: 1a2b3c4d" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","id":1}'
```

- User with `Rl-Plan-Free: 1a2b3c4d` can make 150000 requests/month.
- Exceeding this will result in HTTP 429 responses.

### Rate Limit Response Headers

When a request is rate limited, Envoy includes the following headers in the response:

```
X-Envoy-RateLimited: true
X-RateLimit-Limit: 150000, 150000;w=2592000
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 3600
```

These headers provide information about rate limits:

- `X-Envoy-RateLimited`: Indicates the request was rate limited
- `X-RateLimit-Limit`: Shows the request quota for the current time window
  - `w` refers to the window size in seconds, eg `w=2592000` is 30 days
- `X-RateLimit-Remaining`: Indicates how many requests remain in the current window
- `X-RateLimit-Reset`: Indicates the number of seconds until the rate limit resets

When multiple rate limits apply (e.g., 150000/month AND 30/second), the headers will display information for the window closest to its limit.

### Setting Header Values

- Set the header on every request downstream of the rate limit service.
- Ways to set headers:
  - [Envoy Gateway HTTP Request Header Modification](https://gateway.envoyproxy.io/docs/tasks/traffic/http-request-headers/)
  - [Envoy Gateway Custom External Authorization](https://gateway.envoyproxy.io/docs/tasks/security/ext-auth/)

> **TODO:** Provide better examples of how to set headers on requests.

```mermaid
graph LR
    Client[Client] -->|Request| Gateway[Envoy Gateway]
    Gateway -->|Set Header| RateLimit[Rate Limit Service]
    RateLimit -->|Forward Allowed Request| Upstream[PATH]

    classDef client fill:#f9f,stroke:#333,stroke-width:2px,color:black
    classDef gateway fill:#bbf,stroke:#333,stroke-width:2px,color:black
    classDef ratelimit fill:#bfb,stroke:#333,stroke-width:2px,color:black
    classDef upstream fill:#fbb,stroke:#333,stroke-width:2px,color:black

    class Client client
    class Gateway gateway
    class RateLimit ratelimit
    class Upstream upstream
```

## Rate Limiting Configuration

- All config is in `values.yaml` under `rateLimit`.
- Key parameters:

| Parameter                    | Description                                        | Default          | Required |
| ---------------------------- | -------------------------------------------------- | ---------------- | -------- |
| `rateLimit.enabled`          | Enable rate limiting                               | `true`           | ✅        |
| `rateLimit.redis.enabled`    | Deploy Redis from this chart                       | `true`           | ❌        |
| `rateLimit.plans`            | Array of rate limit plans                          |                  | ✅        |
| `rateLimit.plans[].header`   | Header for identifying rate limit subjects         | `"Rl-Plan-Free"` | ✅        |
| `rateLimit.plans[].requests` | Requests allowed per time unit                     | `150000`         | ✅        |
| `rateLimit.plans[].unit`     | Time unit (Second, Minute, Hour, Day, Month, Year) | `Month`          | ✅        |

### Default Configuration

```yaml
rateLimit:
  enabled: true
  redis:
    enabled: true
  plans:
    - header: "Rl-Plan-Free"
      requests: 150000
      unit: Month
```

- Limits each unique `Rl-Plan-Free` header value to 150000 requests/month.

### Adding New Rate Limit Plans

- Add new entries to the `plans` array.
- Example: Add a "pro" plan with 1000 requests/hour:

```yaml
plans:
  - header: "Rl-Plan-Free"
    requests: 150000
    unit: Month
  - header: "Rl-Plan-Pro"
    requests: 5000
    unit: Day
```

- `Rl-Plan-Free: XXX` → 150000/month
- `Rl-Plan-Pro: XXX` → 5000/day

### Multiple Rate Limits per Plan

- Add multiple entries with the same header for different units.
- Example: Limit "free" users to 150000/month **AND** 30/second:

```yaml
plans:
  - header: "Rl-Plan-Free"
    requests: 150000
    unit: Month
  - header: "Rl-Plan-Free"
    requests: 30
    unit: Second
```

### Redis Configuration

- **Redis is required** as a backend for rate limiting.
- By default, Redis is deployed by the chart.

#### Using External Redis

1. Set `rateLimit.redis.enabled: false`
2. Set the Redis URL in `gateway-helm.config.envoyGateway.rateLimit.backend.redis.url`
3. If using authentication, configure it separately.

Example:

```yaml
rateLimit:
  enabled: true
  redis:
    enabled: false
  plans:
    - header: "Rl-Plan-Free"
      requests: 150000
      unit: Month

gateway-helm:
  config:
    envoyGateway:
      rateLimit:
        backend:
          type: Redis
          redis:
            url: my-external-redis.example.com:6379
```

> **NOTE:** If you disable Redis deployment, you MUST set the correct external Redis URL as above.

## Gateway Helm Configuration

- The following config must be set in `gateway-helm` in `values.yaml`:

```yaml
gateway-helm:
  config:
    envoyGateway:
      rateLimit:
        backend:
          type: Redis
          redis:
            url: redis:6379
```

- By default, this points to the Redis deployed by the chart in the same namespace.

### Enabling X-RateLimit Headers

To configure Envoy to include rate limit headers in responses, add the following to your `gateway-helm` configuration:

```yaml
gateway-helm:
  config:
    envoyGateway:
      extensionServices:
        rateLimit:
          enableXRateLimitHeaders: DRAFT_VERSION_03
```

This enables the standard rate limit headers (`X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`) according to the [draft RFC specification](https://datatracker.ietf.org/doc/html/draft-polli-ratelimit-headers-03).

:::note Disabling Redis

If `rateLimit.redis.enabled` is `false`, update the above URL to your external Redis.

:::

:::warning Modifying Namespace

If you change the namespace, update the Redis URL to `redis.<NAMESPACE>.svc.cluster.local:6379`.

:::

## Common Tasks

- **Enable/disable rate limiting:** Set `rateLimit.enabled: true|false` in `values.yaml`
- **Change rate limits:** Edit the `plans` array
- **Switch to external Redis:** See [Redis Configuration](#redis-configuration)
- **Change namespace:** Update Redis URL in `gateway-helm` config
- **Enable rate limit headers:** See [Enabling X-RateLimit Headers](#enabling-x-ratelimit-headers)

## Documentation References

- [Envoy Gateway Helm Chart Values](https://github.com/envoyproxy/gateway/tree/main/charts/gateway-helm#values)
- [Envoy Gateway Helm Chart Values Template](https://github.com/envoyproxy/gateway/blob/main/charts/gateway-helm/values.tmpl.yaml)
- [Envoy Gateway Rate Limiting](https://gateway.envoyproxy.io/docs/tasks/traffic/global-rate-limit/)
- [Envoy Proxy Rate Limit HTTP Filter](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/rate_limit_filter)
- [Envoy Rate Limit Headers Documentation](https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/filters/http/ratelimit/v3/rate_limit.proto)
- [Envoy Proxy Rate Limit Repo](https://github.com/envoyproxy/ratelimit)
