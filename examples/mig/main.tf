module "gke_tabnine" {
  source                                    = "../.."
  project_id                                = local.project_id
  region                                    = "<REGION>"
  zones                                     = ["<ZONE>"]
  prefix                                    = "<A-PREFIX>"
  create_vpc                                = true
  create_service_account                    = true
  ingress                                   = { host = local.host, internal = false }
  pre_shared_cert_name                      = google_compute_managed_ssl_certificate.tabnine_cert.name
  create_tabnine_storage_bucket_im_bindings = false
  organization_id                           = "<ORGANIZATION-ID>"
  organization_secret                       = "<ORGANIZATION-SECRET>"
  use_nvidia_mig                            = true
}

terraform {
  backend "gcs" {
    bucket = "<BUCKET>"
    prefix = "<DIR-IN-BUCKET>"
  }
}

resource "google_compute_managed_ssl_certificate" "tabnine_cert" {
  name    = local.cert_name
  project = local.project_id

  managed {
    domains = [local.host]
  }
}

locals {
  cert_name  = "<CERT-NAME>"
  host       = "<HOST-NAME>"
  project_id = "<PROJECT-ID>"
}
