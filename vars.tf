variable "organization_id" {
  description = "organization ID"
  type        = string
}

variable "organization_secret" {
  description = "Organization Secret"
  type        = string
}

variable "organization_name" {
  description = "Organization Name"
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
    host     = string
    internal = bool
  })

  default = null
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

variable "create_deny_all_firewall_rules" {
  description = "Should create deny all firewall rules"
  type        = bool
  default     = true
}


variable "pre_shared_cert_name" {
  description = "Use this if you already uploaded a pre-shared cert"
  type        = string
  default     = null
}

variable "create_managed_cert" {
  description = "Create google managed certificate"
  type        = bool
  default     = false
}

variable "upload_pre_shared_cert" {
  description = "Use this to upload pre-shared cert"
  type = object({
    path_to_private_key = string
    path_to_certificate = string
  })

  default = null
}

variable "tabnine_cloud_values" {
  description = "Tabnine cloud helm charts values, see https://github.com/codota/helm-charts/blob/master/charts/tabnine-cloud/values.yaml"
  type        = list(string)
  default     = []
}
variable "use_nvidia_mig" {
  description = "Should use MIG for the GPU (see https://docs.nvidia.com/datacenter/tesla/mig-user-guide/#partitioning)"
  type        = bool
  default     = false
}

variable "enforce_jwt" {
  description = "Should enforce JWT for user authentication"
  type        = bool
  default     = true
}

variable "rudder_write_key" {
  description = "Pass analytics pipeline key"
  type        = string
  default     = null
}

variable "use_spot_instances" {
  description = "Should use spot instances"
  type        = bool
  default     = false
}

variable "min_gpu_machines" {
  description = "Minimum number of GPU instances"
  type        = number
  default     = 1
}

variable "db_master_zone" {
  description = "Database master zone. If not set, will default to first zone"
  type        = string
  default     = null
}

variable "default_email" {
  description = "The first user to be put in the database. Password will be automatically generated"
  type        = string
}

variable "drop_all_analytics" {
  description = "Should the analytics service forward telemetry to Tabnine servers"
  type        = bool
  default     = false
}

variable "smtp_host" {
  description = "SMTP server host address"
  type        = string
}

variable "smtp_user" {
  description = "SMTP server user"
  type        = string
}


variable "smtp_password" {
  description = "SMTP server password"
  type        = string
}

locals {
  db_master_zone             = var.db_master_zone != null ? var.db_master_zone : data.google_compute_zones.available.names[0]
  network_name               = var.create_vpc ? format("%s-gke", var.prefix) : var.network_name
  subnetwork                 = var.create_vpc ? format("%s-gke", var.prefix) : var.subnetwork
  subnetwork_proxy_only      = var.create_vpc ? format("%s-gke-proxy-only", var.prefix) : var.subnetwork_proxy_only
  ip_range_pods              = var.create_vpc ? format("%s-gke-pods", var.prefix) : var.ip_range_pods
  ip_range_services          = var.create_vpc ? format("%s-gke-services", var.prefix) : var.ip_range_services
  private_service_connect_ip = "10.10.40.1"
  service_account_email      = var.create_service_account ? module.service_accounts[0].service_account.email : var.service_account_email
  create_ingress             = var.ingress != null
  pre_shared_cert_name       = var.ingress != null ? (var.upload_pre_shared_cert != null ? google_compute_ssl_certificate.pre_shared_cert[0].name : var.pre_shared_cert_name) : null
  tabnine_static_ip          = "34.123.33.186"
  gke_master_ipv4_cidr_block = "10.0.0.0/28"
  gke_metadata_server_ip     = "169.254.169.254"
  gpu_partition_size         = var.use_nvidia_mig ? "3g.20gb" : null
}
