variable "create_managed_cert" {
  type    = bool
  default = null
}

variable "tls_cert" {
  type = string
  default = null
}

variable "tls_key" {
  type = string
  default = null
}

variable "email_from_field" {
  type = string
}

variable "smtp_host" {
  type = string
}

variable "smtp_pass" {
  type = string
}

variable "smtp_user" {
  type = string
}

variable "tabnine_registry_username" {
  type = string
}

variable "tabnine_registry_password" {
  type      = string
  sensitive = true
}

variable "redis_url" {
  type = string
}

variable "redis_ca" {
  type = string
}

variable "db_url" {
  type = string
}

variable "db_ca" {
  type = string
}

variable "db_cert" {
  type = string
}

variable "db_private_key" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "domain" {
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
