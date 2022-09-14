module "gke_tabnine" {
  source                 = "../.."
  project_id             = "<PROJECT-ID>"
  region                 = "<REGION>"
  zones                  = ["<ZONE>"]
  prefix                 = "<PREFIX-OF-RESOURECS>"
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
    bucket = "<BUCKET>"
    prefix = "<PREFIX>"
  }
}


