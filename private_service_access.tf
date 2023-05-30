module "private_service_access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  project_id  = var.project_id
  vpc_network = module.vpc.network_name

  address = "10.18.0.0"

  depends_on = [
    // TODO feels like this is needed due to a bug
    module.vpc.network
  ]
}
