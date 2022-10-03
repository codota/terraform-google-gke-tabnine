resource "helm_release" "tabnine_cloud" {
  name       = "tabnine-cloud"
  repository = "tabnine"
  chart      = "tabnine-cloud"
  wait       = false
  version    = "v1.0.8"

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
    for_each = local.create_ingress && !local.ingress_internal ? [1] : []
    content {
      name  = "ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name"
      value = module.address_fe.names[0]
    }
  }

  dynamic "set" {
    for_each = local.create_ingress && local.ingress_internal ? [1] : []
    content {
      name  = "ingress.annotations.kubernetes\\.io/ingress\\.regional-static-ip-name"
      value = module.address_fe.names[0]
    }
  }

  dynamic "set" {
    for_each = local.create_ingress && local.ingress_internal ? [1] : []
    content {
      name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
      value = "gce-internal"
    }
  }

}

resource "helm_release" "fluentd" {
  name       = "fluentd"
  repository = "fluent"
  chart      = "fluentd"
  wait       = false
  version    = "v0.3.9"

  values = [
    templatefile("${path.module}/fluentd_values.yaml.tpl", { private_key = var.es_private_key })
  ]

}
