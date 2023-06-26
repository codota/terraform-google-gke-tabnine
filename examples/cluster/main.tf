// Tabnine cluster module
module "gke_cluster_tabnine" {
  source                      = "codota/gke-tabnine/google//modules/cluster"
  project_id                  = var.project_id
  region                      = var.region
  zones                       = var.zones
  prefix                      = var.prefix
  exclude_kubernetes_manifest = var.exclude_kubernetes_manifest

  firewall_rules = {
    deny_all = false

    allow = [
      {
        ranges = ["111.111.111.111/32"]
        name   = "allow-smtp"
        ports = [
          { number = ["587"], protocol = "TCP" }
        ]
    }]
  }
}

output "endpoint" {
  description = "Cluster endpoint"
  value       = module.gke.endpoint
}

output "ca_certificate" {
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.gke.ca_certificate
}

output "redis_url" {
  value     = "rediss://:${module.memstore.auth_string}@${module.memstore.host}:${module.memstore.port}"
  sensitive = true
}

output "redis_ca_base64" {
  value = base64encode(module.memstore.server_ca_certs[0].cert)
}

output "db_url" {
  value     = "postgres://tabnine:${urlencode(module.sql_db.generated_user_password)}@${module.sql_db.private_ip_address}:5432/tabnine"
  sensitive = true
}

output "db_ca_base64" {
  description = "Database ca certificate (base64 encoded)"
  value       = base64encode(google_sql_ssl_cert.sql_db.server_ca_cert)
}

output "db_cert_base64" {
  description = "Database server cert certificate (base64 encoded)"
  value       = base64encode(google_sql_ssl_cert.sql_db.cert)
}

output "db_private_key_base64" {
  description = "Database client private key (base64 encoded)"
  value       = base64encode(google_sql_ssl_cert.sql_db.private_key)
}
