module "gke_tabnine" {
  source                                    = "../.."
  project_id                                = "<PROJECT-ID>"
  region                                    = "<REGION>"
  zones                                     = ["<ZONE>"]
  prefix                                    = "<A-PREFIX>"
  create_vpc                                = true
  create_service_account                    = true
  exclude_nvidia_driver                     = var.exclude_nvidia_driver
  ingress                                   = { host = "demo-cloud.tabnine.com", internal = false }
  pre_shared_cert_name                      = "<PRE-SHARED-CERT-NAME>"
  create_tabnine_storage_bucket_im_bindings = false
  organization_id                           = "<ORGANIZATION-ID>"
  organization_secret                       = "<ORGANIZATION-SECRET>"
  use_nvidia_mig                            = true
}


variable "exclude_nvidia_driver" {
  type    = bool
  default = false
}

terraform {
  backend "gcs" {
    bucket = "<BUCKET>"
    prefix = "<DIR-IN-BUCKET>"
  }
}