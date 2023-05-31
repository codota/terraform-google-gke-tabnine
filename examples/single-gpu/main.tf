module "gke_tabnine" {
  source                                    = "../.."
  project_id                                = "<PROJECT-ID>"
  region                                    = "<REGION>"
  zones                                     = ["<ZONE>"]
  prefix                                    = "<A-PREFIX>"
  ingress                                   = { host = "tabnine.customer.com", internal = false }
  pre_shared_cert_name                      = "<PRE-SHARED-CERT-NAME>"
  create_tabnine_storage_bucket_im_bindings = false
  organization_id                           = "<ORGANIZATION-ID>"
  organization_secret                       = "<ORGANIZATION-SECRET>"
  organization_name                         = "<ORGANIZATION-NAME>"
  tabnine_cloud_values                      = [file("${path.module}/tabnine_cloud_values.yaml")]
  exclude_kubernetes_manifest               = var.exclude_kubernetes_manifest

  firewall_rules = {
    deny_all = true

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

output "ingress_ip" {
  value = module.gke_tabnine.ingress_ip
}

output "default_password" {
  value     = module.gke_tabnine.default_password
  sensitive = true
}

variable "exclude_kubernetes_manifest" {
  description = "Exclude kubernetes manifest installations. This should be off during initial installation"
  type        = bool
  default     = false
}


terraform {
  backend "gcs" {
    bucket = "<BUCKET>"
    prefix = "<DIR-IN-BUCKET>"
  }
}
