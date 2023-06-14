resource "kubernetes_secret_v1" "tabnine_registry_credentials" {
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

