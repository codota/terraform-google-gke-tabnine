// SSL certificate to attach to Tabnine ingress
resource "google_compute_managed_ssl_certificate" "tabnine_cloud" {
  name = "tabnine-cloud-managed-cert"

  managed {
    domains = [var.domain]
  }
}
