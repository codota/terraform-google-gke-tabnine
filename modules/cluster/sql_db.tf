locals {
  db_region = var.db_region != "" ? var.db_region : var.region
}
module "sql_db" {
  source               = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version              = "21.0.0"
  name                 = format("%s-db", var.prefix)
  random_instance_name = true
  project_id           = var.project_id
  database_version     = "POSTGRES_16"
  region               = local.db_region

  // Master configurations
  tier                            = "db-custom-2-7680"
  zone                            = local.db_master_zone
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  deletion_protection = false

  ip_configuration = {
    ipv4_enabled       = false
    require_ssl        = true
    private_network    = module.vpc.network_self_link
    allocated_ip_range = module.private_service_access.google_compute_global_address_name
    authorized_networks = [
    ]
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "20:55"
    location                       = null
    point_in_time_recovery_enabled = false
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }

  db_name      = "tabnine"
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"

  user_name = "tabnine"

  depends_on = [
    module.private_service_access.peering_completed
  ]
}

resource "google_sql_ssl_cert" "sql_db" {
  common_name = "tabnine-cloud"
  instance    = module.sql_db.instance_name
}

