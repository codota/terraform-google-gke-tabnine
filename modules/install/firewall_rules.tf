module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.project_id
  network_name = var.network_name

  rules = [{
    name               = "${var.prefix}-allow-smtp"
    direction          = "EGRESS"
    destination_ranges = ["${var.smtp_ip}/32"]
    allow = [{
      protocol = "tcp"
    }]
  }]
}
