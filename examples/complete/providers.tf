provider "google" {
  project = var.project_id
}

terraform {
  backend "gcs" {
    bucket = "tabnine-tf-state"
    prefix = "assaf-self-hosted-0"
  }
}
