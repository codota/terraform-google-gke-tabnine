module "private_service_connect" {
  source = "terraform-google-modules/network/google//modules/private-service-connect"

  project_id                   = var.project_id
  network_self_link            = module.vpc[0].network_self_link
  private_service_connect_ip   = local.private_service_connect_ip
  forwarding_rule_target       = "all-apis"
  dns_code                     = format("%s-dns", var.prefix)
  private_service_connect_name = format("%s-psconnect", var.prefix)
  forwarding_rule_name         = random_string.forwarding_rule_name.result
}

resource "random_string" "forwarding_rule_name" {
  lower   = true
  upper   = false
  numeric = true
  special = false
  length  = 10
  keepers = {
    forwarding_rule_name = var.prefix
  }
}
