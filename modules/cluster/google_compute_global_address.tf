// Regional static IP to attach to Tabnine ingress
resource "google_compute_address" "ingress" {
  name   = "${var.prefix}-tabnine-cloud"
  region = var.region
}
