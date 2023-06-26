// SSL certificate to attach to Tabnine ingress
resource "google_compute_managed_ssl_certificate" "tabnine_cloud" {
  count = var.create_managed_cert ? 1 : 0
  name  = format("%s-tabnine-cloud", var.prefix)

  managed {
    domains = [var.tabnine_address_name]
  }
}
