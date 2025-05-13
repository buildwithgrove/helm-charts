## Routing Capabilities

GUARD provides two primary routing methods:

### Subdomain-Based Routing

Subdomain-based routing directs traffic based on the subdomain in the request URL. This type of routing is configured in the `httproute-subdomain.yaml` template.

**Example Configuration:**

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

With this configuration, GUARD will:

1. Create routes for each service ID and its aliases
2. Set the `target-service-id` header to the canonical service ID
3. Forward the request to the appropriate backend service

**URL Examples:**

- `https://F00C.path.example.com/v1` → Routes to PATH with `target-service-id: F00C`
- `https://eth.path.example.com/v1` → Routes to PATH with `target-service-id: F00C`
- `https://eth-mainnet.path.example.com/v1` → Routes to PATH with `target-service-id: F00C`
- `https://polygon.path.example.com/v1` → Routes to PATH with `target-service-id: F021`

### Header-Based Routing

Header-based routing directs traffic based on the `target-service-id` header in the request. This type of routing is configured in the `httproute-header.yaml` template.

**Example Configuration:**

Using the same services configuration as above, header-based routing enables clients to specify the target service in the header:

**URL and Header Examples:**

- `https://path.example.com/v1` with header `-H "target-service-id: F00C"` → Routes to PATH with `target-service-id: F00C`
- `https://path.example.com/v1` with header `-H "target-service-id: eth"` → Routes to PATH with `target-service-id: F00C`
- `https://path.example.com/v1` with header `-H "target-service-id: polygon"` → Routes to PATH with `target-service-id: F021`

### Route Examples

**Example 1: Using curl with subdomain routing**

```bash
# Route to ETH service using subdomain
curl https://eth.path.example.com/v1
  -H "Authorization: test_api_key"
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

**Example 2: Using curl with header routing**

```bash
# Route to ETH service using header
curl https://path.example.com/v1
  -H "Target-Service-Id: eth"
  -H "Authorization: test_api_key"
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```
