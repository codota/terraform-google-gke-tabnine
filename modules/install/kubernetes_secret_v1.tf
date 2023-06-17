resource "kubernetes_secret_v1" "registry_credentials" {
  metadata {
    name      = "tabnine-registry-credentials"
    namespace = kubernetes_namespace.tabnine.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "registry.tabnine.com" = {
          "username" = var.tabnine_registry_username
          "password" = var.tabnine_registry_password
          "auth"     = base64encode("${var.tabnine_registry_username}:${var.tabnine_registry_password}")
        }
      }
    })
  }
}

resource "kubernetes_secret_v1" "tls_certificate" {
  count = var.tls_cert !=null && var.tls_key !=null ? 1 : 0
  metadata {
    name      = "tabnine-ssl-certificate"
    namespace = kubernetes_namespace.tabnine.metadata[0].name
  }

  data = {
    "tls.crt" = var.tls_cert
    "tls.key" = var.tls_key
  }

  type = "kubernetes.io/tls"
}
