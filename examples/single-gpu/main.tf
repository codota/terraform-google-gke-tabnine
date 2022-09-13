module "gke-tabnine" {
  source                     = "../terraform-google-gke-tabnine"
  project_id                 = "tabnine"
  region                     = "us-central1"
  zones                      = ["us-central1-a", "us-central1-c"]
  prefix                     = "galco"
  create_vpc                 = true
  create_service_account     = true
}
terraform {
  backend "gcs" {
    bucket = "tabnine-tf-state"
    prefix = "self-hosted-galco"
  }
}


