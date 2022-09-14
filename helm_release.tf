resource "helm_release" "tabnine_cloud" {
  name       = "tabnine-cloud"
  repository = "tabnine"
  chart      = "tabnine-cloud"

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
      value = var.ingress_host
    }
  }

}
