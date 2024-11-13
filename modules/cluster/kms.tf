module "kms" {
  source             = "terraform-google-modules/kms/google"
  version            = "2.3.0"
  project_id         = var.project_id
  location           = var.region
  keyring            = format("%s-keyring", var.prefix)
  keys               = ["gke"]
  set_encrypters_for = ["gke"]
  set_decrypters_for = ["gke"]
  prevent_destroy    = false
  decrypters = [
    format("serviceAccount:service-%s@container-engine-robot.iam.gserviceaccount.com", data.google_project.project.number)
  ]
  encrypters = [
    format("serviceAccount:service-%s@container-engine-robot.iam.gserviceaccount.com", data.google_project.project.number)
  ]
}

resource "google_kms_key_ring" "encryption_service_keyring" {
  for_each = toset(var.encryption_service_kms_keyrings)

  name     = "encryption-service-${each.key}"
  project  = var.project_id
  location = "global"
}
