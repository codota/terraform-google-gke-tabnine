module "gke_tabnine" {
  source                 = "../.."
  project_id             = "<PROJECT-ID>"
  region                 = "<REGION>"
  zones                  = ["<ZONE>"]
  prefix                 = "<PREFIX-OF-RESOURECS>"
  create_vpc             = true
  create_service_account = true
# when passing service account email, make sure create_service_account is set to false  
# service_account_email  = "<YOUR-SERVICE-ACCOUNT_EMAIL>" 
  exclude_nvidia_driver  = var.exclude_nvidia_driver
  ingress                = { host = "demo-cloud.tabnine.com", internal = true }
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


