module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 2.2"

  project_id     = var.project_id
  location       = var.region
  keyring        = format("%s-keyring", var.prefix)
  keys           = ["gke"]
  set_owners_for = ["gke"]
  owners = [
    format("serviceAccount:%s", local.service_account_email)
  ]
}
