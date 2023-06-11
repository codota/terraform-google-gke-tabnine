data "google_client_config" "default" {}

data "google_project" "project" {}

provider "google" {
  project = var.project_id
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.tabnine_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.tabnine_cluster.ca_certificate)
  }
}

provider "kubernetes" {
  host                   = "https://${module.tabnine_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.tabnine_cluster.ca_certificate)
}

terraform {
  backend "gcs" {
    bucket = "tabnine-tf-state"
    prefix = "assaf-self-hosted-0"
  }
}
