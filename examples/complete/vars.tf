variable "create_managed_cert" {
  type    = bool
  default = false
}

variable "tls_cert_path" {
  type    = string
  default = null
}

variable "tls_key_path" {
  type    = string
  default = null
}


variable "email_from_field" {
  type = string
}

variable "smtp_host" {
  type = string
}

variable "smtp_auth_pass" {
  type    = string
  default = null
}

variable "smtp_auth_user" {
  type    = string
  default = null
}

variable "tabnine_registry_username" {
  type = string
}

variable "tabnine_registry_password" {
  type = string
}

variable "tabnine_address_name" {
  type = string
}

variable "organization_id" {
  type = string
}

variable "organization_name" {
  type = string
}

variable "organization_secret" {
  type = string
}

variable "organization_domain" {
  type = string
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

variable "default_email" {
  type = string
}

variable "exclude_kubernetes_manifest" {
  description = "Exclude kubernetes manifest installations. This should be off during initial installation"
  type        = bool
  default     = false
}

variable "license_key" {
  type = string
}

variable "gke_master_authorized_networks" {
  type = list(object({
    cidr_block   = string,
    display_name = string
  }))
}
