module "private_service_access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  project_id  = var.project_id
  vpc_network = local.network_name

  address = "10.18.0.0"

  depends_on = [
    module.vpc
  ]
}
