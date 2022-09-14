module "gke_tabnine" {
  source                 = "../.."
  project_id             = "proud-maker-166101"
  region                 = "us-central1"
  zones                  = ["us-central1-a", "us-central1-c"]
  prefix                 = "bilu"
  create_vpc             = true
  create_service_account = true
  exclude_nvidia_driver  = var.exclude_nvidia_driver
  ingress_host           = "demo-cloud.tabnine.com"
}


variable "exclude_nvidia_driver" {
  type    = bool
  default = false
}

terraform {
  backend "gcs" {
    bucket = "tabnine-tf-state"
    prefix = "bilu-self-hosted"
  }
}


