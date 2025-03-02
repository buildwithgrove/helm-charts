# Remove the k8s_resource that's not working reliably
# k8s_resource(
#     new_name = "envoy-gateway",
#     workload = "guard", # This refers to the helm release name
#     extra_pod_selectors = [
#         {"control-plane": "envoy-gateway"},
#     ],
#     port_forwards = ["3070:3070"],
#     pod_readiness = "wait",
# )

# Add a local_resource to dynamically find and port-forward the envoy gateway pod
local_resource(
    "envoy-gateway-port-forward",
    "sh -c \"svc=\$(kubectl -n path-local get svc -l gateway.envoyproxy.io/owning-gateway-name=envoy-gateway -o jsonpath='{.items[0].metadata.name}') && echo 'Port forwarding service' \$svc 'on port 3070' && kubectl -n path-local port-forward service/\$svc 3070:3070\"",
    resource_deps = ["guard"]
) 