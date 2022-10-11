variable "customer_id" {
  description = "Customer ID"
  type        = string
}

variable "create_tabnine_storage_bucket_im_bindings" {
  description = "Create Tabnine storage bucket im bindings. Should be set to true only when run by Tabnine team"
  type        = bool
  default     = false
}

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

variable "create_vpc" {
  description = "Should create a VPC, or used the one provided by `network_name`"
  type        = bool
  default     = false
}

variable "create_service_account" {
  description = "Should create a service_account, or used the one provided by `service_account_email`"
  type        = bool
  default     = false
}

variable "ingress" {
  description = "Configuration of inference engine"

  type = object({
    host     = string,
    internal = bool
  })

  default = {
    host     = ""
    internal = true
  }
}

variable "network_name" {
  description = "VPC name, used when `create_vpc` is set to `false` "
  type        = string
  default     = ""
}

variable "subnetwork" {
  description = "VPC subnetwork name, used when `create_vpc` is set to `false` "
  type        = string
  default     = ""
}

variable "subnetwork_proxy_only" {
  description = "VPC subnetwork proxy only name, used when `create_vpc` is set to `false` "
  type        = string
  default     = ""
}

variable "ip_range_pods" {
  description = "Pods ip range, used when `create_vpc` is set to `false` "
  type        = string
  default     = ""
}

variable "ip_range_services" {
  description = "Services ip range, used when `create_vpc` is set to `false` "
  type        = string
  default     = ""
}

variable "service_account_email" {
  description = "Service account email, used when `create_service_account` is set to `false` "
  type        = string
  default     = ""
}

variable "exclude_nvidia_driver" {
  description = "Should exclude nvidia driver from installation"
  type        = bool
  default     = false
}

variable "es_private_key" {
  type = string
}


locals {
  network_name          = var.create_vpc ? format("%s-gke", var.prefix) : var.network_name
  subnetwork            = var.create_vpc ? format("%s-gke", var.prefix) : var.subnetwork
  subnetwork_proxy_only = var.create_vpc ? format("%s-gke-proxy-only", var.prefix) : var.subnetwork_proxy_only
  ip_range_pods         = var.create_vpc ? format("%s-gke-pods", var.prefix) : var.ip_range_pods
  ip_range_services     = var.create_vpc ? format("%s-gke-services", var.prefix) : var.ip_range_services
  service_account_email = var.create_service_account ? module.service_accounts[0].service_account.email : var.service_account_email
  create_ingress        = var.ingress.host != ""
  ingress_internal      = var.ingress.internal == null || var.ingress.internal
}


