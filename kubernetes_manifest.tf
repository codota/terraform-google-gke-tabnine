resource "kubernetes_manifest" "frontend_config_tabnine_cloud" {
  manifest = {

    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"
    metadata = {
      name      = "tabnine-cloud"
      namespace = "default"
    }
    spec = {
      sslPolicy = google_compute_ssl_policy.min_tls_v_1_2.name
    }
  }

  depends_on = [
    module.gke
  ]
}

