frontendConfig:
  enabled: true
  sslPolicyName: ${ssl_policy_name}

service:
  type: NodePort

frontend:
  enforceJWT: ${enforce_jwt}

ingress:
  enabled: ${ingress != null }
  host: ${ingress != null ? ingress.host : ""}
  certificate:
    managed: ${create_managed_cert}
    %{if pre_shared_cert_name != null }
    preSharedName: ${pre_shared_cert_name}
    %{endif}


networkPolicy:
  enabled: true
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
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: nats
    ports:
     - port: 4222
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

tabnine:
    organizationId: "${organization_id}"
