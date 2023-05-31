resource "kubernetes_manifest" "frontend_config_tabnine_cloud" {
  count = var.exclude_kubernetes_manifest ? 0 : 1
  manifest = {

    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"
    metadata = {
      name      = "tabnine-cloud"
      namespace = "default"
    }
    spec = {
      sslPolicy = google_compute_ssl_policy.min_tls_v_1_2.name
      redirectToHttps = {
        enabled          = "true"
        responseCodeName = "MOVED_PERMANENTLY_DEFAULT"
      }
    }
  }

  depends_on = [
    module.gke
  ]
}

