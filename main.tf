terraform {
  backend "gcs" {
    bucket = "tabnine-tf-state"
    prefix = "self-hosted-tests"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}


