// Tabnine cluster module
module "gke_cluster_tabnine" {
  source                         = "codota/gke-tabnine/google//modules/cluster"
  project_id                     = var.project_id
  region                         = var.region
  zones                          = var.zones
  prefix                         = var.prefix
  exclude_kubernetes_manifest    = var.exclude_kubernetes_manifest
  gke_master_authorized_networks = var.gke_master_authorized_networks
}


output "redis_url" {
  value     = module.gke_cluster_tabnine.redis_url
  sensitive = true
}

output "redis_ca_base64" {
  value = base64encode(module.gke_cluster_tabnine.redis_ca)
}

output "db_url" {
  value     = module.gke_cluster_tabnine.db_url
  sensitive = true
}

output "db_ca_base64" {
  description = "Database ca certificate (base64 encoded)"
  value       = base64encode(module.gke_cluster_tabnine.db_ca)
}

output "db_cert_base64" {
  description = "Database server certificate (base64 encoded)"
  value       = base64encode(module.gke_cluster_tabnine.db_cert)
}

output "db_private_key_base64" {
  description = "Database client private key (base64 encoded)"
  value       = base64encode(module.gke_cluster_tabnine.db_private_key)
  sensitive   = true
}
