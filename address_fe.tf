module "address_fe" {
  source       = "terraform-google-modules/address/google"
  version      = "~> 3.1"
  project_id   = var.project_id
  region       = var.region
  subnetwork   = local.ingress_internal ? local.subnetwork : null
  purpose      = "GCE_ENDPOINT"
  address_type = local.ingress_internal ? "INTERNAL" : "EXTERNAL"

  names = [
    "${var.prefix}-tabnine-cloud"
  ]

  global = !local.ingress_internal

  depends_on = [
    module.vpc
  ]
}
