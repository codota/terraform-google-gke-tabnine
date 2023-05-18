module "sql_db" {
  source               = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version              = "15.0.0"
  name                 = format("%s-db", var.prefix)
  random_instance_name = true
  project_id           = var.project_id
  database_version     = "POSTGRES_12"
  region               = var.region

  // Master configurations
  tier                            = "db-custom-2-7680"
  zone                            = local.db_master_zone
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  deletion_protection = true

  ip_configuration = {
    ipv4_enabled       = true
    require_ssl        = true
    private_network    = data.google_compute_network.vpc.self_link
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

  # additional_users = [
  #   {
  #     name            = "tftest3"
  #     password        = "abcdefg"
  #     host            = "localhost"
  #     random_password = false
  #   },
  # ]
  depends_on = [
    module.private_service_access.peering_completed
  ]
}

module "private_service_access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  project_id  = var.project_id
  vpc_network = local.network_name

  depends_on = [
    module.vpc
  ]
}

resource "google_sql_ssl_cert" "sql_db" {
  common_name = "tabnine-cloud"
  instance    = module.sql_db.instance_name
}

