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
