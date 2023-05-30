module "address_fe" {
  source       = "terraform-google-modules/address/google"
  version      = "~> 3.1"
  project_id   = var.project_id
  region       = var.region
  subnetwork   = var.ingress.internal ? local.subnetwork : null
  purpose      = "GCE_ENDPOINT"
  address_type = var.ingress.internal ? "INTERNAL" : "EXTERNAL"

  names = [
    "${var.prefix}-tabnine-cloud"
  ]

  global = !var.ingress.internal
}
