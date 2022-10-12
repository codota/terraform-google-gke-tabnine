resource "google_compute_ssl_certificate" "pre_shared_cert" {
  count       = var.upload_pre_shared_cert != null ? 1 : 0
  name_prefix = var.prefix
  description = "Used by Tabnine Inference Engine"
  private_key = file(var.upload_pre_shared_cert.path_to_private_key)
  certificate = file(var.upload_pre_shared_cert.path_to_certificate)

  lifecycle {
    create_before_destroy = true
  }
}
