// Tabnine's helm chart. This is the main resource.
resource "helm_release" "tabnine_cloud" {
  name      = "tabnine-cloud"
  chart     = "oci://registry.tabnine.com/self-hosted/tabnine-cloud"
  wait      = false
  version   = "4.1.2"
  namespace = kubernetes_namespace.tabnine.metadata[0].name

  values = concat([
    templatefile("${path.module}/tabnine_cloud_values.yaml.tftpl", {
      tabnine_registry_credentials = kubernetes_secret_v1.registry_credentials.metadata[0].name
      default_email                = var.default_email
      global_static_ip             = google_compute_global_address.ingress.name
      ssl_policy_name              = google_compute_ssl_policy.min_tls_v_1_2.name,
      organization_id              = var.organization_id
      organization_name            = var.organization_name
      domain                       = var.domain,
      pre_shared_cert_name         = length(google_compute_managed_ssl_certificate.tabnine_cloud) > 0  ? google_compute_managed_ssl_certificate.tabnine_cloud[0].name : null
      frontend_config_name         = "tabnine-cloud",
      db_ca_base64                 = base64encode(var.db_ca),
      db_cert_base64               = base64encode(var.db_cert)
      redis_ca_base64              = base64encode(var.redis_ca)
      smtp_user                    = var.smtp_user
      smtp_host                    = var.smtp_host
      email_from_field             = var.email_from_field
    }),

    templatefile("${path.module}/tabnine_cloud_sensitive_values.yaml.tftpl", {
      domain                     = var.domain,
      db_url                     = var.db_url,
      db_cert_private_key_base64 = base64encode(var.db_private_key)
      redis_url                  = var.redis_url
      organization_secret        = var.organization_secret
      smtp_pass                  = var.smtp_pass
      tls_secret_name            = length(kubernetes_secret_v1.tls_certificate)>0 ? kubernetes_secret_v1.tls_certificate[0].metadata[0].name : null
    }),
    ]
  )

  depends_on = [
    # helm_release.prometheus
  ]
}

// Prometheus helm chart. This is needed if telemetry enabled.
resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
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
