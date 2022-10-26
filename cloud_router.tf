module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"
  project = var.project_id # Replace this with your project ID in quotes
  name    = format("%s-router", var.prefix)
  network = local.network_name
  region  = var.region

  nats = [{
    name = format("%s-nat-gateway", var.prefix)
  }]
}
