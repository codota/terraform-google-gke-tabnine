resource "helm_release" "tabnine_cloud" {
  name       = "tabnine-cloud"
  repository = "tabnine"
  chart      = "tabnine-cloud"
  wait       = false
  version    = "3.17.0"

  values = concat([
    templatefile("${path.module}/tabnine_cloud_values.yaml.tftpl", {
      default_email        = var.default_email
      global_static_ip     = google_compute_global_address.ingress.name
      ssl_policy_name      = google_compute_ssl_policy.min_tls_v_1_2.name,
      organization_id      = var.organization_id
      organization_name    = var.organization_name
      domain               = var.domain,
      pre_shared_cert_name = google_compute_managed_ssl_certificate.tabnine_cloud.name,
      frontend_config_name = "tabnine-cloud",
      db_ca_base64         = base64encode(module.tabnine_cluster.db_ca),
      db_cert_base64       = base64encode(module.tabnine_cluster.db_cert)
      redis_ca_base64      = base64encode(module.tabnine_cluster.redis_ca)
    }),

    templatefile("${path.module}/tabnine_cloud_sensitive_values.yaml.tftpl", {
      db_url                     = module.tabnine_cluster.db_url,
      db_cert_private_key_base64 = base64encode(module.tabnine_cluster.db_private_key)
      redis_url                  = module.tabnine_cluster.redis_url
      organization_secret        = var.organization_secret
    }),
    ]
  )

  depends_on = [
    helm_release.prometheus
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
