defaultRules:
  create: true
  rules:
    general: true
    k8s: true
    node: true
    prometheusOperator: true

alertmanager:
  enabled: false

grafana:
  enabled: false

kubeApiServer:
  enabled: false

kubelet:
  enabled: false

kubeControllerManager:
  enabled: false

coreDns:
  enabled: true

nodeExporter:
  enabled: true

prometheusOperator:
  enabled: true
  networkPolicy:
    enabled: true

  enableFeatures:
    - agent

prometheus:
  prometheusSpec:
    remoteWrite:
      - url: 'https://logs-gateway.tabnine.com/prometheus'
        name: 'tabnine'
        remoteTimeout: 120s
        headers:
         x-organization-id: '${organization_id}'
         x-organization-secret: '${organization_secret}'
        writeRelabelConfigs:
            - targetLabel: organization_id
              replacement: '${organization_id}'
            - targetLabel: organization_name
              replacement: '${organization_name}'
    podMonitorSelectorNilUsesHelmValues: false
    podMonitorSelector: {}
    podMonitorNamespaceSelector: {}
