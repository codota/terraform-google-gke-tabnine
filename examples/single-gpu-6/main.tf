module "gke_tabnine" {
  source                                    = "../.."
  project_id                                = "proud-maker-166101"
  region                                    = "us-central1"
  zones                                     = ["us-central1-a"]
  prefix                                    = "bilu-6"
  create_vpc                                = true
  create_service_account                    = true
  exclude_nvidia_driver                     = var.exclude_nvidia_driver
  ingress                                   = { host = "demo-cloud.tabnine.com", internal = false }
  create_tabnine_storage_bucket_im_bindings = true
  create_deny_all_firewall_rules            = false
  organization_id                           = "8f304a7d-b93f-41e5-bddb-5646c346ed04"
  organization_secret                       = "8f304a7d-b93f-41e5-bddb-5646c346ed04"
  pre_shared_cert_name                      = "demo-cloud-tabnine-com"
  rudder_write_key                          = <need to get rudder write key>
  cloud_host_name                           = "tabnine-demo-cloud"
}


variable "exclude_nvidia_driver" {
  type    = bool
  default = false
}

terraform {
  backend "gcs" {
    bucket = "tabnine-tf-state"
    prefix = "bilu-self-hosted-6"
  }
}


