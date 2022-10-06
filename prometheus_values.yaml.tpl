# Default values for kube-prometheus-stack.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

## Provide a name in place of kube-prometheus-stack for `app:` labels
##
nameOverride: ""

## Override the deployment namespace
##
namespaceOverride: ""

## Provide a k8s version to auto dashboard import script example: kubeTargetVersionOverride: 1.16.6
##
kubeTargetVersionOverride: ""

## Allow kubeVersion to be overridden while creating the ingress
##
kubeVersionOverride: ""

## Provide a name to substitute for the full names of resources
##
fullnameOverride: ""

## Labels to apply to all resources
##
commonLabels: {}
# scmhash: abc123
# myLabel: aakkmd

## Create default rules for monitoring the cluster
##
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

## Component scraping coreDns. Use either this or kubeDns
##
coreDns:
  enabled: true
  service:
    port: 9153
    targetPort: 9153
    # selector:
    #   k8s-app: kube-dns
  serviceMonitor:
    ## Scrape interval. If not set, the Prometheus default scrape interval is used.
    ##
    interval: ""

    ## proxyUrl: URL of a proxy that should be used for scraping.
    ##
    proxyUrl: ""

    ## MetricRelabelConfigs to apply to samples after scraping, but before ingestion.
    ## ref: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#relabelconfig
    ##
    metricRelabelings: []
    # - action: keep
    #   regex: 'kube_(daemonset|deployment|pod|namespace|node|statefulset).+'
    #   sourceLabels: [__name__]

    ## RelabelConfigs to apply to samples before scraping
    ## ref: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#relabelconfig
    ##
    relabelings: []
    # - sourceLabels: [__meta_kubernetes_pod_node_name]
    #   separator: ;
    #   regex: ^(.*)$
    #   targetLabel: nodename
    #   replacement: $1
    #   action: replace

    ## Additional labels
    ##
    additionalLabels: {}
    #  foo: bar

## Configuration for kube-state-metrics subchart
##
kube-state-metrics:
  namespaceOverride: ""
  rbac:
    create: true
  releaseLabel: true
  prometheus:
    monitor:
      enabled: true
      metricRelabelings: []
      # - action: keep
      #   regex: 'kube_(daemonset|deployment|pod|namespace|node|statefulset).+'
      #   sourceLabels: [__name__]

      ## RelabelConfigs to apply to samples before scraping
      ## ref: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#relabelconfig
      ##
      relabelings: []
      # - sourceLabels: [__meta_kubernetes_pod_node_name]
      #   separator: ;
      #   regex: ^(.*)$
      #   targetLabel: nodename
      #   replacement: $1
      #   action: replace

## Deploy node exporter as a daemonset to all nodes
##
nodeExporter:
  enabled: true

## Configuration for prometheus-node-exporter subchart
##
prometheus-node-exporter:
  prometheus:
    monitor:
      enabled: true
      metricRelabelings: []
      # - sourceLabels: [__name__]
      #   separator: ;
      #   regex: ^node_mountstats_nfs_(event|operations|transport)_.+
      #   replacement: $1
      #   action: drop

      ## RelabelConfigs to apply to samples before scraping
      ## ref: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#relabelconfig
      ##
      relabelings: []
      # - sourceLabels: [__meta_kubernetes_pod_node_name]
      #   separator: ;
      #   regex: ^(.*)$
      #   targetLabel: nodename
      #   replacement: $1
      #   action: replace

prometheusOperator:
  enabled: true
  enableFeatures:
    - agent

prometheus:
  prometheusSpec:
    remoteWrite: 
      - url: 'https://prometheus-gateway.coralogix.us/prometheus/api/v1/write'
        name: 'tabnine'
        remoteTimeout: 120s
        bearerToken: '${private_key}'
    podMonitorSelectorNilUsesHelmValues: false
    podMonitorSelector: {}
    podMonitorNamespacSelector: {}



