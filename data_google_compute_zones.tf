data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
}
