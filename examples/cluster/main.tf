// Tabnine cluster module
module "gke_cluster_tabnine" {
  source                                    = "../../modules/tabnine_cluster/"
  project_id                                = var.project_id
  region                                    = var.region
  zones                                     = var.zones
  prefix                                    = var.prefix
  create_tabnine_storage_bucket_im_bindings = false
  exclude_kubernetes_manifest               = var.exclude_kubernetes_manifest

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
