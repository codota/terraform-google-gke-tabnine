global:
  frontendConfig:
    enabled: true
    sslPolicyName: ${ssl_policy_name}
  ingress:
    enabled: ${ingress != null }
    host: ${ingress != null ? ingress.host : ""}
    annotations:
      %{if pre_shared_cert_name != null }
      ingress.gcp.kubernetes.io/pre-shared-cert: ${pre_shared_cert_name}
      %{endif}
      networking.gke.io/v1beta1.FrontendConfig: ${frontend_config_name}

  tabnine:
    organizationId: "${organization_id}"


frontend:
  service:
    type: NodePort
    port: 8080
  enforceJWT: ${enforce_jwt}
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


server:
  service:
    type: NodePort
    port: 8081
  nodeSelector:
    "cloud.google.com/gke-accelerator": "nvidia-tesla-a100"


analytics:
  service:
    type: NodePort
    port: 8082

update:
  service:
    type: NodePort
    port: 8083

app:
  service:
    type: NodePort
    port: 8084

auth:
  defaultEmail: ${default_email}
  service:
    type: NodePort
    port: 8085
