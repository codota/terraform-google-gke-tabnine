module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 5.0.1"
  name    = format("%s-router", var.prefix)
  network = module.vpc.network_name
  project = var.project_id
  region  = var.region

  nats = [{
    name = format("%s-nat-gateway", var.prefix)
  }]
}
