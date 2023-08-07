data "google_client_config" "default" {}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke_cluster_tabnine.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke_cluster_tabnine.ca_certificate)
  }
}

provider "kubernetes" {
  host                   = "https://${module.gke_cluster_tabnine.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_cluster_tabnine.ca_certificate)
}
