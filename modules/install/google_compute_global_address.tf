// Global static IP to attach to Tabnine ingress
resource "google_compute_global_address" "ingress" {
  name = "${var.prefix}-tabnine-cloud"
}
