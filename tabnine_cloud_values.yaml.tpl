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
        cidr: 169.254.169.254/32 #This is metadata server url https://cloud.google.com/kubernetes-engine/docs/concepts/workload-identity#metadata_server
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
