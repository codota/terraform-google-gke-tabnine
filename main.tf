terraform {
  backend "gcs" {
    bucket = "tabnine-tf-state"
    prefix = "self-hosted-tests"
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["container", "clusters", "get-credentials", module.gke.name, "--region", var.region, "--project", var.project_id]
      command     = "gcloud"
    }
  }
}


provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["container", "clusters", "get-credentials", module.gke.name, "--region", var.region, "--project", var.project_id]
    command     = "gcloud"
  }
}


