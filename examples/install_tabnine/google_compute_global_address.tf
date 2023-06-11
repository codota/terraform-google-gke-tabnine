resource "google_compute_global_address" "ingress" {
  name        = "${var.prefix}-tabnine-cloud"
}
