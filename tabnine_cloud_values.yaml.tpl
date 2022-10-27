service:
  annotations:
    cloud.google.com/neg: '{"ingress": true}'

networkPolicy:
  enabled: true 
  ingress: 
    - from:
      - namespaceSelector:
          matchLabels:
            name: prometheus 
      ports:
        - protocol: TCP
          port: 8002
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
