variable "prefix" {
  type    = string
  default = "tabnine-self-hosted"
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zones" {
  type = list(string)
}

variable "create_vpc" {
  type    = bool
  default = false
}

variable "create_service_account" {
  type    = bool
  default = false
}

variable "ingress_host" {
  type    = string
  default = ""
}


variable "network_name" {
  type    = string
  default = ""
}

variable "subnetwork" {
  type    = string
  default = ""
}

variable "ip_range_pods" {
  type    = string
  default = ""
}

variable "ip_range_services" {
  type    = string
  default = ""
}

variable "service_account_email" {
  type    = string
  default = ""
}

variable "exclude_nvidia_driver" {
  type    = bool
  default = false
}

locals {
  network_name          = var.create_vpc ? format("%s-gke", var.prefix) : var.network_name
  subnetwork            = var.create_vpc ? format("%s-gke", var.prefix) : var.subnetwork
  ip_range_pods         = var.create_vpc ? format("%s-gke-pods", var.prefix) : var.ip_range_pods
  ip_range_services     = var.create_vpc ? format("%s-gke-services", var.prefix) : var.ip_range_services
  service_account_email = var.create_service_account ? module.service_accounts[0].service_account.email : var.service_account_email
  create_ingress        = var.ingress_host != ""
}


