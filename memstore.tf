module "memstore" {
  source = "terraform-google-modules/memorystore/google"

  name = format("%s-redis", var.prefix)

  project                 = var.project_id
  region                  = var.region
  enable_apis             = true
  auth_enabled            = true
  transit_encryption_mode = "SERVER_AUTHENTICATION"
  connect_mode            = "PRIVATE_SERVICE_ACCESS"
  authorized_network      = module.vpc.network_id
  memory_size_gb          = 2
  persistence_config = {
    persistence_mode    = "RDB"
    rdb_snapshot_period = "ONE_HOUR"
  }

  depends_on = [
    module.private_service_access.peering_completed
  ]
}
