module "private_service_connect" {
  source = "terraform-google-modules/network/google//modules/private-service-connect"

  project_id                 = var.project_id
  network_self_link          = module.vpc[0].network_self_link
  private_service_connect_ip = local.private_service_connect_ip
  forwarding_rule_target     = "all-apis"
}
