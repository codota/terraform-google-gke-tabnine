module "private_service_access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  vpc_network = module.vpc.network_name
  project_id  = var.project_id

  address = "10.18.0.0"

  depends_on = [
    // TODO feels like this is needed due to a bug
    module.vpc.network
  ]
}
