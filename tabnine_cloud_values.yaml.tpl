frontendConfig:
  enabled: true
  sslPolicyName: ${ssl_policy_name}

service:
  type: NodePort

networkPolicy:
  enabled: ${network_policy_enabled}
  ingress: 
  - {}
  egress:
  - to:
    - ipBlock:
        cidr: ${private_service_connect_ip}/32
    ports:
    - port: 443
      protocol: TCP
  - to:
    - ipBlock:
        cidr: ${gke_metadata_server_ip}/32 
    ports:
    - port: 80
      protocol: TCP
  - ports:
    - port: 53
      protocol: UDP
    to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
      podSelector:
        matchLabels:
          k8s-app: kube-dns
