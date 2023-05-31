data "kubernetes_secret" "default_password" {
  metadata {
    name = "default-password"
  }

  binary_data = {
    password = ""
  }

  depends_on = [
    helm_release.tabnine_cloud
  ]
}
