resource "helm_release" "tabnine_cloud" {
  name       = "tabnine-cloud"
  repository = "tabnine"
  chart      = "tabnine-cloud"
  wait       = false
  version    = "3.15.0"

  values = concat([
    templatefile("${path.module}/tabnine_cloud_values.yaml.tftpl", {
      private_service_connect_ip = local.private_service_connect_ip,
      gke_metadata_server_ip     = local.gke_metadata_server_ip,
      ssl_policy_name            = google_compute_ssl_policy.min_tls_v_1_2.name,
      organization_id            = var.organization_id,
      organization_name          = var.organization_name,
      organization_secret        = var.organization_secret
      license_key                = var.license_key,
      ingress                    = var.ingress,
      pre_shared_cert_name       = var.create_managed_cert ? google_compute_managed_ssl_certificate.tabnine_cloud[0].name : (var.upload_pre_shared_cert != null ? google_compute_ssl_certificate.pre_shared_cert[0].name : var.pre_shared_cert_name)
      frontend_config_name       = "tabnine-cloud",
      db = { ca_base64 = base64encode(google_sql_ssl_cert.sql_db.server_ca_cert),
        cert_base64 = base64encode(google_sql_ssl_cert.sql_db.cert)
      },
      redis = { ca_base64 = base64encode(module.memstore.server_ca_certs[0].cert) }
    }),

    templatefile("${path.module}/tabnine_cloud_sensitive_values.yaml.tftpl", {
      db = { url = "postgres://tabnine:${urlencode(module.sql_db.generated_user_password)}@${module.sql_db.private_ip_address}:5432/tabnine",
        cert_private_key_base64 = base64encode(google_sql_ssl_cert.sql_db.private_key)
      }
      redis = { url = "rediss://:${module.memstore.auth_string}@${module.memstore.host}:${module.memstore.port}" }
    }),
    ],
    var.tabnine_cloud_values
  )

  // these need to be templated like the other attributes above
  dynamic "set" {
    for_each = local.create_ingress && var.rudder_write_key != null ? [1] : []
    content {
      name  = "frontend.cloudHostName"
      value = var.ingress.host
    }
  }

  dynamic "set" {
    for_each = var.rudder_write_key != null ? [1] : []
    content {
      name  = "frontend.rudderWriteKey"
      value = var.rudder_write_key
    }
  }

  dynamic "set" {
    for_each = local.create_ingress && !var.ingress.internal ? [1] : []
    content {
      name  = "global.ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name"
      value = module.address_fe.names[0]
    }
  }

  dynamic "set" {
    for_each = local.create_ingress && var.ingress.internal ? [1] : []
    content {
      name  = "global.ingress.annotations.kubernetes\\.io/ingress\\.regional-static-ip-name"
      value = module.address_fe.names[0]
    }
  }

  dynamic "set" {
    for_each = local.create_ingress && var.ingress.internal ? [1] : []
    content {
      name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
      value = "gce-internal"
    }
  }

  depends_on = [
    helm_release.prometheus
  ]
}

resource "helm_release" "fluentd" {
  name             = "fluentd"
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluentd"
  namespace        = "fluentd"
  wait             = false
  version          = "0.3.9"
  create_namespace = true

  values = [
    templatefile("${path.module}/fluentd_values.yaml.tftpl", {
      organization_id     = var.organization_id,
      organization_secret = var.organization_secret,
      organization_name   = var.organization_name
    })
  ]
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "prometheus"
  wait             = false
  version          = "44.3.0"
  create_namespace = true
  cleanup_on_fail  = true

  values = [
    templatefile("${path.module}/prometheus_values.yaml.tftpl", {
      organization_id     = var.organization_id,
      organization_secret = var.organization_secret,
      organization_name   = var.organization_name
    })
  ]
}


resource "helm_release" "nats" {
  name             = "nats"
  chart            = "nats"
  repository       = "https://nats-io.github.io/k8s/helm/charts/"
  version          = "0.19.12"
  namespace        = "nats"
  create_namespace = true
  wait             = false

  set {
    name  = "natsbox.enabled"
    value = "true"
  }
  values = [
    "${file("${path.module}/nats_values.yaml")}"
  ]
}
