resource "google_compute_managed_ssl_certificate" "tabnine_cloud" {
  count = var.create_managed_cert ? 1 : 0
  name  = format("%s-managed-cert", var.prefix)

  managed {
    domains = [var.ingress.host]
  }
}
