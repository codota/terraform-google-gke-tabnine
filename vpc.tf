module "vpc" {
  count   = var.create_vpc ? 1 : 0
  source  = "terraform-google-modules/network/google"
  version = "~> 4.0"

  project_id   = var.project_id
  network_name = local.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = local.subnetwork
      subnet_ip     = "10.10.20.0/24"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    (local.subnetwork) = [
      {
        range_name    = local.ip_range_pods
        ip_cidr_range = "192.167.0.0/16"
      },
      {
        range_name    = local.ip_range_services
        ip_cidr_range = "192.168.63.0/24"
      },
    ]
  }
}
