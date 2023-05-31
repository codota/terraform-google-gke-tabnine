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

variable "ingress" {
  description = "Configuration of inference engine"

  type = object({
    host     = string
    internal = bool
  })

  default = null
}

variable "firewall_rules" {
  description = "Egress firewall rules configuration"
  type = object({
    deny_all = bool
    allow = list(object({
      name   = string
      ranges = list(string)
      ports = list(object({
        number   = list(string)
        protocol = string
      }))
    }))
  })
  default = {
    deny_all = true
    allow    = []
  }
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

variable "exclude_kubernetes_manifest" {
  description = "Exclude kubernetes manifest installations. This should be off during initial installation"
  type        = bool
  default     = false
}


locals {
  db_master_zone             = var.db_master_zone != null ? var.db_master_zone : data.google_compute_zones.available.names[0]
  private_service_connect_ip = "10.10.40.1"
  create_ingress             = var.ingress != null
  pre_shared_cert_name       = var.ingress != null ? (var.upload_pre_shared_cert != null ? google_compute_ssl_certificate.pre_shared_cert[0].name : var.pre_shared_cert_name) : null
  tabnine_static_ip          = "34.123.33.186"
  gke_master_ipv4_cidr_block = "10.0.0.0/28"
  gke_metadata_server_ip     = "169.254.169.254"
  gpu_partition_size         = var.use_nvidia_mig ? "3g.20gb" : null
}
