module "memstore" {
  source = "terraform-google-modules/memorystore/google"

  name = format("%s-redis", var.prefix)

  project                 = var.project_id
  region                  = var.region
  enable_apis             = true
  auth_enabled            = true
  transit_encryption_mode = "SERVER_AUTHENTICATION"
  connect_mode            = "PRIVATE_SERVICE_ACCESS"
  authorized_network      = data.google_compute_network.vpc.id
  memory_size_gb          = 2
  persistence_config = {
    persistence_mode    = "RDB"
    rdb_snapshot_period = "ONE_HOUR"
  }
}