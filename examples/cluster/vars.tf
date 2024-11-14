variable "prefix" {
  description = "Prefix all resources names"
  type        = string
  default     = "tabnine-self-hosted"
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zones" {
  description = "GCP zones"
  type        = list(string)
}

variable "exclude_kubernetes_manifest" {
  description = "Exclude kubernetes manifest installations. This should be off during initial installation"
  type        = bool
  default     = false
}

variable "gke_master_authorized_networks" {
  type = list(object({
    cidr_block   = string,
    display_name = string
  }))
}

variable "kms_iam_service_account_name" {
  description = "The name of the IAM service account for using kms"
  type        = string
}

variable "kms_kubernetes_service_account_namespace" {
  description = "The kubernetes namespace where the kms service account resides"
  type        = string
}
