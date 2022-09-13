module "gke-tabnine" {
  source                     = "../"
  project_id                 = "tabnine"
  region                     = "us-central1"
  zones                      = ["us-central1-a", "us-central1-c"]
  prefix                     = "your-prefix"
  create_vpc                 = true
  create_service_account     = true
}
terraform {
  backend "gcs" {
    bucket = "your-bucket"
    prefix = "your-prefix"
  }
}


