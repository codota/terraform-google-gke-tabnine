resource "helm_release" "tabnine_cloud" {
  name       = "tabnine-cloud"
  repository = "tabnine"
  chart      = "tabnine-cloud"
  wait       = false
  version    = "2.2.5"

  values = [
    templatefile("${path.module}/tabnine_cloud_values.yaml.tpl", {
      private_service_connect_ip = local.private_service_connect_ip,
      gke_metadata_server_ip     = local.gke_metadata_server_ip,
      ssl_policy_name            = google_compute_ssl_policy.min_tls_v_1_2.name,
      organization_id            = var.organization_id,
      enforce_jwt                = var.enforce_jwt
    })
  ]


  dynamic "set" {
    for_each = local.create_ingress ? [1] : []
    content {
      name  = "ingress.enabled"
      value = "true"
    }
  }

  dynamic "set" {
    for_each = local.create_ingress ? [1] : []
    content {
      name  = "ingress.host"
      value = var.ingress.host
    }
  }

  dynamic "set" {
    for_each = local.create_ingress && var.rudder_write_key != null ? [1] : []
    content {
      name  = "frontend.cloudHostName"
      value = var.ingress.host
    }
  }

  dynamic "set" {
    for_each = var.rudder_write_key != null ? [1] : []
    content {
      name  = "frontend.rudderWriteKey"
      value = var.rudder_write_key
    }
  }

  dynamic "set" {
    for_each = local.create_ingress && !var.ingress.internal ? [1] : []
    content {
      name  = "ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name"
      value = module.address_fe.names[0]
    }
  }

  dynamic "set" {
    for_each = local.create_ingress && var.ingress.internal ? [1] : []
    content {
      name  = "ingress.annotations.kubernetes\\.io/ingress\\.regional-static-ip-name"
      value = module.address_fe.names[0]
    }
  }

  dynamic "set" {
    for_each = local.create_ingress && var.ingress.internal ? [1] : []
    content {
      name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
      value = "gce-internal"
    }
  }

  dynamic "set" {
    for_each = local.pre_shared_cert_name != null ? [1] : []
    content {
      name  = "ingress.annotations.ingress\\.gcp\\.kubernetes\\.io/pre-shared-cert"
      value = local.pre_shared_cert_name
    }
  }


  depends_on = [
    helm_release.prometheus
  ]
}

resource "helm_release" "fluentd" {
  name             = "fluentd"
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluentd"
  namespace        = "fluentd"
  wait             = false
  version          = "0.3.9"
  create_namespace = true

  values = [
    templatefile("${path.module}/fluentd_values.yaml.tpl", {
      organization_id     = var.organization_id,
      organization_secret = var.organization_secret
    })
  ]
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "prometheus"
  wait             = false
  version          = "44.3.0"
  create_namespace = true
  cleanup_on_fail  = true

  values = [
    templatefile("${path.module}/prometheus_values.yaml.tpl", {
      organization_id     = var.organization_id,
      organization_secret = var.organization_secret
    })
  ]
}
