module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "6.0.2"
  name    = format("%s-router", var.prefix)
  network = module.vpc.network_name
  project = var.project_id
  region  = var.region

  nats = [
    {
      name    = format("%s-nat-gateway", var.prefix)
      nat_ips = var.nat_ips
    }
  ]
}
