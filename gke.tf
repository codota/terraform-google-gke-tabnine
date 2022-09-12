module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  project_id                 = var.project_id
  name                       = format("%s-gke", var.prefix)
  region                     = var.region
  zones                      = var.zones
  network                    = local.network_name
  subnetwork                 = local.subnetwork
  ip_range_pods              = local.ip_range_pods
  ip_range_services          = local.ip_range_services
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  service_account            = local.service_account_email
  identity_namespace         = "null"
  node_metadata              = "UNSPECIFIED"

  node_pools = [
    {
      name               = format("%s-default", var.prefix)
      machine_type       = "a2-highgpu-1g"
      machine_type       = "e2-medium"
      node_locations     = "us-central1-a"
      min_count          = 1
      max_count          = 3
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
      node_locations     = "us-central1-a"
      min_count          = 1
      max_count          = 1
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
}

