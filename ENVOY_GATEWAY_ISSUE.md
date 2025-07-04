# HTTPRouteFilter URLRewrite with ReplaceRegexMatch fails to rewrite paths correctly

## Description

When using HTTPRouteFilter with URLRewrite and ReplaceRegexMatch to strip a path prefix, the rewrite does not work as expected. Specifically, when attempting to rewrite `/v1/<appid>` to `/`, the original path is still sent to the backend instead of the rewritten path.

The expected behavior is that a request to `/v1/0caa84c4` should be rewritten to `/` before being forwarded to the backend. Instead, the backend receives the original path `/v1/0caa84c4`.

## Repro steps

1. Create a Backend resource pointing to an external service:

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: Backend
metadata:
  name: xrplevm-testnet-external-0
  namespace: middleware
spec:
  endpoints:
  - ip:
      address: 45.77.195.1
      port: 8545
```

2. Create an HTTPRouteFilter for URL rewriting:

```yaml
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: HTTPRouteFilter
metadata:
  name: xrplevm-testnet-external-0-rewrite
  namespace: middleware
spec:
  urlRewrite:
    path:
      type: ReplaceRegexMatch
      replaceRegexMatch:
        pattern: "^/v1/[^/]+"
        substitution: ""
```

3. Create an HTTPRoute that references both resources:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: xrplevm-testnet-subdomain-route
  namespace: middleware
spec:
  parentRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: guard-envoy-gateway
  hostnames:
  - "xrpl-evm-testnet.rpc.grove.city"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /v1
    backendRefs:
    - group: gateway.envoyproxy.io
      kind: Backend
      name: xrplevm-testnet-external-0
      filters:
      - type: ExtensionRef
        extensionRef:
          group: gateway.envoyproxy.io
          kind: HTTPRouteFilter
          name: xrplevm-testnet-external-0-rewrite
```

4. Send a request:

```bash
curl https://xrpl-evm-testnet.rpc.grove.city/v1/0caa84c4 \
  -X POST \
  -H 'Content-Type: application/json' \
  -d '{"method": "eth_blockNumber", "params": [], "id": 1, "jsonrpc": "2.0"}'
```

5. Observe that the backend receives the request at `/v1/0caa84c4` instead of `/`:

Backend server logs show:
```
35.198.88.116 - - [02/Jul/2025 00:52:52] "POST /v1/0caa84c4 HTTP/1.1" 501 -
```

Expected backend server logs:
```
35.198.88.116 - - [02/Jul/2025 00:52:52] "POST / HTTP/1.1" 200 -
```

## Additional Testing

We've tried multiple regex patterns, all with the same result:
- `^/v1/[^/]+` → `` (should result in `/` but doesn't)
- `^/v1/[^/]+(.*)$` → `$1/` (doesn't work correctly)
- `^(/v1/[^/]+)(.*)` → `$2/` (doesn't work correctly)

We also observed that:
1. The HTTPRouteFilter is accepted without validation errors
2. The HTTPRoute shows as accepted but with a warning about specific filter support within BackendRef
3. The regex pattern appears to not be applied at all

## Environment

- Gateway API version: v1
- Envoy Gateway version: v1alpha1
- Kubernetes version: (please fill in)
- Cloud Provider: GCP/GKE

## Logs

HTTPRoute status showing the filter acceptance issue:
```yaml
status:
  parents:
  - conditions:
    - lastTransitionTime: "2025-07-02T00:00:54Z"
      message: Route is accepted
      observedGeneration: 8
      reason: Accepted
      status: "True"
      type: Accepted
    - lastTransitionTime: "2025-07-02T00:00:54Z"
      message: 'Failed to process route rule 0 backendRef 3: Specific filter is not
        supported within BackendRef, only RequestHeaderModifier, ResponseHeaderModifier
        and gateway.envoyproxy.io/HTTPRouteFilter are supported.'
      observedGeneration: 8
      reason: UnsupportedRefValue
      status: "False"
      type: ResolvedRefs
    controllerName: gateway.envoyproxy.io/gatewayclass-controller
```

Access logs and Envoy debug logs: (please provide if available)

## Expected Behavior

The HTTPRouteFilter with ReplaceRegexMatch should properly rewrite the URL path before forwarding to the backend. In this case, `/v1/0caa84c4` should be rewritten to `/` when using the pattern `^/v1/[^/]+` with an empty substitution.

## Workaround

Currently, we have to deploy an additional proxy service to handle URL rewriting, which adds unnecessary complexity to the infrastructure.