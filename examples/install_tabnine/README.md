# Install Tabnine Example

This is an example of managing Tabnine infra, as well as application in Terraform.

## Use

`tabnine init -module=terreaform-google-gke-tabnine/examples/install_tabnine`

<!-- BEGIN_TF_DOCS -->
## Resource

* `resource.google_compute_global_address.ingress` [google_compute_global_address.tf#L2](google_compute_global_address.tf#L2)
Global static IP to attach to Tabnine ingress
* `resource.google_compute_managed_ssl_certificate.tabnine_cloud` [google_compute_managed_ssl_certificate.tf#L2](google_compute_managed_ssl_certificate.tf#L2)
SSL certificate to attach to Tabnine ingress
* `resource.google_compute_ssl_policy.min_tls_v_1_2` [google_compute_ssl_policy.tf#L2](google_compute_ssl_policy.tf#L2)
SSL policy to attach to Tabnine ingress. This forces tls 1.2+
* `resource.helm_release.prometheus` [helm_release.tf#L39](helm_release.tf#L39)
Prometheus helm chart. This is needed if telemetry enabled.
* `resource.helm_release.tabnine_cloud` [helm_release.tf#L2](helm_release.tf#L2)
Tabnine's helm chart. This is the main resource.
* `resource.kubernetes_manifest.frontend_config_tabnine_cloud` [kubernetes_manifest.tf#L4](kubernetes_manifest.tf#L4)
Frontend config to attach to Tabnine ingress. It binds SSL policy and forces HTTPS. kubernetes_manifest requires having a cluster in plan time. This is why it needs to be excluded in initial apply
* `data source.google_client_config.default` [providers.tf#L1](providers.tf#L1)

* `data source.google_project.project` [providers.tf#L3](providers.tf#L3)


## Modules

- (tabnine_cluster.tf#2) Tabnine cluster module
<!-- END_TF_DOCS -->
