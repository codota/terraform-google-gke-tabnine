module "gke_cluster_tabnine_install" {
  source                      = "codota/gke-tabnine/google//modules/install"
  project_id                  = var.project_id
  region                      = var.region
  zones                       = var.zones
  prefix                      = var.prefix
  db_url                      = module.gke_cluster_tabnine.db_url
  db_ca                       = module.gke_cluster_tabnine.db_ca
  db_cert                     = module.gke_cluster_tabnine.db_cert
  db_private_key              = module.gke_cluster_tabnine.db_private_key
  db_ip                       = module.gke_cluster_tabnine.db_ip
  redis_url                   = module.gke_cluster_tabnine.redis_url
  redis_ca                    = module.gke_cluster_tabnine.redis_ca
  redis_ip                    = module.gke_cluster_tabnine.redis_ip
  network_name                = module.gke_cluster_tabnine.network_name
  organization_id             = var.organization_id
  organization_secret         = var.organization_secret
  organization_name           = var.organization_name
  organization_domain         = var.organization_domain
  license_key                 = var.license_key
  default_email               = var.default_email
  tabnine_address_name        = var.tabnine_address_name
  exclude_kubernetes_manifest = var.exclude_kubernetes_manifest
  tabnine_registry_username   = var.tabnine_registry_username
  tabnine_registry_password   = var.tabnine_registry_password
  smtp_auth_pass              = var.smtp_auth_pass
  smtp_auth_user              = var.smtp_auth_user
  smtp_host                   = var.smtp_host
  smtp_ip                     = var.smtp_ip
  smtp_port                   = var.smtp_port
  email_from_field            = var.email_from_field
  create_managed_cert         = var.create_managed_cert

  depends_on = [
    module.gke_cluster_tabnine
  ]

}
