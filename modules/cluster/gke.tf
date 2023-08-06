module "gke" {
  source                      = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  project_id                  = var.project_id
  kubernetes_version          = "1.27.3-gke.100"
  name                        = format("%s-gke", var.prefix)
  region                      = var.region
  zones                       = var.zones
  network                     = module.vpc.network.network_name
  subnetwork                  = module.vpc.subnets_names[0]
  ip_range_pods               = module.vpc.subnets_secondary_ranges[0][0].range_name
  ip_range_services           = module.vpc.subnets_secondary_ranges[0][1].range_name
  http_load_balancing         = true
  network_policy              = true
  horizontal_pod_autoscaling  = true
  filestore_csi_driver        = false
  service_account             = module.service_accounts.service_account.email
  identity_namespace          = "null"
  node_metadata               = "UNSPECIFIED"
  logging_service             = "logging.googleapis.com/kubernetes"
  logging_enabled_components  = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  create_service_account      = false
  enable_private_nodes        = true
  master_ipv4_cidr_block      = local.gke_master_ipv4_cidr_block
  remove_default_node_pool    = true
  enable_intranode_visibility = true # on existing cluster, this need to be commented first
  disable_default_snat        = true
  database_encryption         = [{ state = "ENCRYPTED", key_name = module.kms.keys["gke"] }]
  master_authorized_networks = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "all"
    }
  ]

  node_pools = [
    {
      name               = format("%s-default", var.prefix)
      machine_type       = "e2-standard-4"
      node_locations     = join(",", var.zones)
      min_count          = 1
      max_count          = 4
      local_ssd_count    = 0
      spot               = false
      disk_size_gb       = 200
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
    },
    {
      accelerator_type   = "nvidia-tesla-a100"
      accelerator_count  = 1
      name               = format("%s-gpu", var.prefix)
      machine_type       = "a2-highgpu-1g"
      gpu_partition_size = local.gpu_partition_size
      node_locations     = join(",", var.zones)
      min_count          = var.min_gpu_machines
      max_count          = 2
      local_ssd_count    = 0
      spot               = var.use_spot_instances
      disk_size_gb       = 200
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_tags = {
    all = []
  }

  node_pools_labels = {
    all = {
    }
  }

  depends_on = [
    module.private_service_connect
  ]
}
