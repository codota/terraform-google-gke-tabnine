module "vpc" {
  count   = var.create_vpc ? 1 : 0
  source  = "terraform-google-modules/network/google"
  version = "7.0.0"

  project_id   = var.project_id
  network_name = local.network_name


  subnets = [{
    subnet_name           = local.subnetwork
    subnet_ip             = "10.10.20.0/24"
    subnet_flow_logs      = "true"
    subnet_region         = var.region
    subnet_private_access = "true"
    },
    {
      // TODO: dynamically only on internal ingress
      subnet_name   = local.subnetwork_proxy_only
      subnet_ip     = "10.10.30.0/24"
      subnet_region = var.region
      purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
      role          = "ACTIVE"
    },
  ]
  secondary_ranges = {
    (local.subnetwork) = [
      {
        range_name    = local.ip_range_pods
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = local.ip_range_services
        ip_cidr_range = "192.168.64.0/18"
      },
    ],
    (local.subnetwork_proxy_only) = []
  }

  firewall_rules = concat([for _, allow_rule in var.firewall_rules.allow : {
    name      = format("%s-%s", var.prefix, allow_rule.name)
    direction = "EGRESS"
    ranges    = allow_rule.ranges
    priority  = 1000
    allow = [for _, port in allow_rule.ports : {
      protocol = port.protocol
      ports    = port.number
    }]
    }], [for _, firewall_rule in [
    {
      name      = format("%s-allow-http-tabnine", var.prefix)
      direction = "EGRESS"
      ranges    = ["${local.tabnine_static_ip}/32"]
      priority  = 1000
      allow = [{
        protocol = "tcp"
        ports    = ["80", "443"]
      }]
    },
    {
      name      = format("%s-allow-google-healthcheck", var.prefix)
      direction = "EGRESS"
      ranges    = ["130.211.0.0/22", "35.191.0.0/16"]
      priority  = 1000
      allow = [{
        protocol = "tcp"
        ports    = ["443", "80"]
        }
      ]
    },
    {
      name      = format("%s-allow-google-private-service-connect", var.prefix)
      direction = "EGRESS"
      ranges    = ["${local.private_service_connect_ip}/32"]
      priority  = 1000
      allow = [{
        protocol = "all"
        ports    = []
        }
      ]
    },
    {
      name      = format("%s-allow-gke-metadata", var.prefix)
      direction = "EGRESS"
      ranges    = ["${local.gke_metadata_server_ip}/32"]
      priority  = 1000
      allow = [{
        protocol = "tcp"
        ports    = ["80", "443"]
        }
      ]
    },
    {
      name      = format("%s-allow-master-node", var.prefix)
      direction = "EGRESS"
      ranges    = [local.gke_master_ipv4_cidr_block]
      priority  = 1000
      allow = [{
        protocol = "tcp"
        ports    = ["443", "10250"]
        }
      ]
    },
    {
      name      = format("%s-allow-vpc", var.prefix)
      direction = "EGRESS"
      ranges    = ["10.10.20.0/24", "10.10.30.0/24", "10.28.0.0/23", "192.168.0.0/18", "192.168.64.0/18"]
      priority  = 1000
      allow = [{
        protocol = "all"
        ports    = []
        }
      ]
    },
    {
      name      = format("%s-deny-all", var.prefix)
      direction = "EGRESS"
      ranges    = ["0.0.0.0/0"]
      priority  = 65000
      deny = [{
        protocol = "all"
        ports    = []
      }]
    }
  ] : firewall_rule if var.firewall_rules.deny_all == true])

}

data "google_compute_network" "vpc" {
  count = var.create_vpc ? 0 : 1
  name  = local.network_name
}

