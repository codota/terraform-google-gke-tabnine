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

output "redis_ip" {
  value = module.memstore.host
}

output "redis_ca" {
  value = module.memstore.server_ca_certs[0].cert
}

output "db_url" {
  value     = "postgres://tabnine:${urlencode(module.sql_db.generated_user_password)}@${module.sql_db.private_ip_address}:5432/tabnine"
  sensitive = true
}

output "db_ip" {
  value = module.sql_db.private_ip_address
}

output "db_ca" {
  value = google_sql_ssl_cert.sql_db.server_ca_cert
}

output "db_cert" {
  value = google_sql_ssl_cert.sql_db.cert
}

output "db_private_key" {
  value = google_sql_ssl_cert.sql_db.private_key
}
