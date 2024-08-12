variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30.3-gke.1451000"
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

variable "pre_shared_cert_name" {
  description = "Use this if you already uploaded a pre-shared cert"
  type        = string
  default     = null
}

variable "use_nvidia_mig" {
  description = "Should use MIG for the GPU (see https://docs.nvidia.com/datacenter/tesla/mig-user-guide/#partitioning)"
  type        = bool
  default     = false
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

variable "db_region" {
  description = "GCP DB region"
  type        = string
  default     = ""
}

variable "exclude_kubernetes_manifest" {
  description = "Exclude kubernetes manifest installations. This should be off during initial installation"
  type        = bool
  default     = false
}

variable "deny_all_egress" {
  description = "Deny all egress traffic"
  type        = bool
  default     = true
}

variable "gke_master_authorized_networks" {
  type = list(object({
    cidr_block   = string,
    display_name = string
  }))
}

variable "nat_ips" {
  type        = list(string)
  default     = []
  description = "nat_ips (list(string), optional): Self-links of NAT IPs."
}
locals {
  db_master_zone             = var.db_master_zone != null ? var.db_master_zone : data.google_compute_zones.available.names[0]
  private_service_connect_ip = "10.10.40.1"
  tabnine_registry_ip        = "34.72.243.185"
  gke_master_ipv4_cidr_block = "10.0.0.0/28"
  gke_metadata_server_ip     = "169.254.169.254"
  gpu_partition_size         = var.use_nvidia_mig ? "3g.20gb" : null
}
