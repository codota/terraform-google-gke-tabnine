module "gke_tabnine" {
  source                                    = "../.."
  project_id                                = "<PROJECT-ID>"
  region                                    = "<REGION>"
  zones                                     = ["<ZONE>"]
  prefix                                    = "<A-PREFIX>"
  create_vpc                                = true
  create_service_account                    = true
  ingress                                   = { host = "demo-cloud.tabnine.com", internal = false }
  pre_shared_cert_name                      = "<PRE-SHARED-CERT-NAME>"
  create_tabnine_storage_bucket_im_bindings = false
  organization_id                           = "<ORGANIZATION-ID>"
  organization_secret                       = "<ORGANIZATION-SECRET>"
}

terraform {
  backend "gcs" {
    bucket = "<BUCKET>"
    prefix = "<DIR-IN-BUCKET>"
  }
}
