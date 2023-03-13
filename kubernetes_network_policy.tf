# This is temporary until fluent adds support for network policy
resource "kubernetes_network_policy" "fluentd" {
  metadata {
    name      = "fluentd"
    namespace = "fluentd"
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/name"     = "fluentd"
        "app.kubernetes.io/instance" = "fluentd"
      }
    }

    ingress {
      ports {
        port     = "24231"
        protocol = "TCP"
      }

      from {
        namespace_selector {
          match_labels = {
            name = "prometheus"
          }
        }
        pod_selector {
          match_labels = {
            "app.kubernetes.io/name" = "prometheus"
          }
        }
      }
    }

    egress {
      to {
        ip_block {
          cidr = "${local.tabnine_static_ip}/32"
        }
      }
      ports {
        port     = "443"
        protocol = "TCP"
      }
    }

    egress {
      to {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "kube-system"
          }
        }

        pod_selector {
          match_labels = {
            "k8s-app" : "kube-dns"
          }
        }

      }

      ports {
        port     = "53"
        protocol = "UDP"
      }

    }

    policy_types = ["Ingress", "Egress"]
  }
}


resource "kubernetes_network_policy" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = "prometheus"
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/name"     = "prometheus"
        "app.kubernetes.io/instance" = "prometheus-kube-prometheus-prometheus"
      }
    }

    egress {
      to {
        ip_block {
          cidr = "${local.tabnine_static_ip}/32"
        }
      }

      to {
        ip_block {
          cidr = local.gke_master_ipv4_cidr_block
        }

      }

      to {
        namespace_selector {
        }
        pod_selector {
        }
      }

    }


    policy_types = ["Egress"]
  }
}
