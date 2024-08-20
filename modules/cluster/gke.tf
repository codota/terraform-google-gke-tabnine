module "gke" {
  source                        = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  project_id                    = var.project_id
  kubernetes_version            = "1.30.3-gke.1451000"
  name                          = format("%s-gke", var.prefix)
  region                        = var.region
  network                       = module.vpc.network.network_name
  subnetwork                    = module.vpc.subnets_names[0]
  ip_range_pods                 = module.vpc.subnets_secondary_ranges[0][0].range_name
  ip_range_services             = module.vpc.subnets_secondary_ranges[0][1].range_name
  http_load_balancing           = true
  horizontal_pod_autoscaling    = true
  filestore_csi_driver          = false
  service_account               = module.service_accounts.service_account.email
  logging_service               = "logging.googleapis.com/kubernetes"
  logging_enabled_components    = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  monitoring_service            = "monitoring.googleapis.com/kubernetes"
  monitoring_enabled_components = ["SYSTEM_COMPONENTS"]
  create_service_account        = false
  enable_private_nodes          = true
  master_ipv4_cidr_block        = local.gke_master_ipv4_cidr_block
  remove_default_node_pool      = true
  enable_intranode_visibility   = true # on existing cluster, this need to be commented first
  database_encryption           = [{ state = "ENCRYPTED", key_name = module.kms.keys["gke"] }]
  master_authorized_networks    = var.gke_master_authorized_networks
  node_metadata                 = "GKE_METADATA_SERVER"
  release_channel               = "UNSPECIFIED"
  disable_default_snat          = false
  security_posture_mode         = "BASIC"
  datapath_provider             = "ADVANCED_DATAPATH"    # this enable Datapath V2 -> Immutable once cluster is deployed!
  identity_namespace            = "enabled"              # enables default workload identity
  dns_cache                     = true                   # enables NodeLocal DNSCache	
  enable_cost_allocation        = true                   # enables Cost Allocation Feature
  enable_gcfs                   = true                   # enables image streaming on cluster level
  maintenance_start_time        = "2024-01-01T06:00:00Z" # need to specify both start and end, only the TIME window matters
  maintenance_end_time          = "2024-01-01T18:00:00Z" # need to specify both start and end, only the TIME window matters
  maintenance_recurrence        = "FREQ=WEEKLY;BYDAY=SA" # weekly recurrence on saturday

  node_pools = [
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
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = false
      initial_node_count = 1
      gpu_driver_version = "LATEST"
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
