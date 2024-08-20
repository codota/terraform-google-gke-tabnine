# Tabnine Install Module

This module is used to install Tabnine on top of existing GKE cluster.

## Prerequistes

- Terraform 1.2.3+
- [helm](https://helm.sh/)
- GKE cluster running


## Use

```hcl
module "gke_cluster_tabnine_install" {
  source                      = "terraform-google-gke-tabnine//modules/install/"
  project_id                  = "<PROJECT-ID>"
  region                      = "<REGION>"
  zones                       = "<ZONES>"
  prefix                      = "<PREFIX>"
  cluster_endpoint            = "<CLUSTER-ENDPOINT>"
  cluster_ca_certificate      = "<CLUSTER-CA-CERTIFICATE>"
  db_url                      = "<DB-URL>"
  db_ca                       = "<DB-CA>"
  db_cert                     = "<DB-CERT>"
  db_private_key              = "<DB-PRIVATE-KEY>"
  redis_url                   = "<REDIS-URL>"
  redis_ca                    = "<REDIS-CA>"
  organization_id             = "<ORGANIZATION-ID>"
  organization_secret         = "<ORGANIZATION-SECRET>"
  organization_name           = "<ORGANIZATION-NAME>"
  default_email               = "<DEFAULT-EMAIL>"
  domain                      = "<DOMAIN>"
  exclude_kubernetes_manifest = true/false
  pre_shared_cert_name        = "<GCP-PRE-SHARED-CERT-NAME>"
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_managed_cert"></a> [create\_managed\_cert](#input\_create\_managed\_cert) | Whether to create managed cert, otherwise use `tls_cert` and `tls_key` | `bool` | `null` | no |
| <a name="input_db_ca"></a> [db\_ca](#input\_db\_ca) | n/a | `string` | n/a | yes |
| <a name="input_db_cert"></a> [db\_cert](#input\_db\_cert) | n/a | `string` | n/a | yes |
| <a name="input_db_ip"></a> [db\_ip](#input\_db\_ip) | n/a | `string` | n/a | yes |
| <a name="input_db_private_key"></a> [db\_private\_key](#input\_db\_private\_key) | n/a | `string` | n/a | yes |
| <a name="input_db_url"></a> [db\_url](#input\_db\_url) | n/a | `string` | n/a | yes |
| <a name="input_default_email"></a> [default\_email](#input\_default\_email) | n/a | `string` | n/a | yes |
| <a name="input_email_from_field"></a> [email\_from\_field](#input\_email\_from\_field) | email to be used in the from `field` for emails sent from Tabnine | `string` | n/a | yes |
| <a name="input_exclude_kubernetes_manifest"></a> [exclude\_kubernetes\_manifest](#input\_exclude\_kubernetes\_manifest) | Exclude kubernetes manifest installations. This should be off during initial installation | `bool` | `false` | no |
| <a name="input_license_key"></a> [license\_key](#input\_license\_key) | n/a | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | n/a | `string` | n/a | yes |
| <a name="input_organization_domain"></a> [organization\_domain](#input\_organization\_domain) | Organization domain | `string` | `"tabnine.io"` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | Organization ID | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | Organization name | `string` | n/a | yes |
| <a name="input_organization_secret"></a> [organization\_secret](#input\_organization\_secret) | Organization secret | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix all resources names | `string` | `"tabnine-self-hosted"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_redis_ca"></a> [redis\_ca](#input\_redis\_ca) | n/a | `string` | n/a | yes |
| <a name="input_redis_ip"></a> [redis\_ip](#input\_redis\_ip) | n/a | `string` | n/a | yes |
| <a name="input_redis_url"></a> [redis\_url](#input\_redis\_url) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | n/a | yes |
| <a name="input_saml_cert"></a> [saml\_cert](#input\_saml\_cert) | n/a | `string` | `null` | no |
| <a name="input_saml_enabled"></a> [saml\_enabled](#input\_saml\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_saml_entrypoint"></a> [saml\_entrypoint](#input\_saml\_entrypoint) | n/a | `string` | `null` | no |
| <a name="input_saml_wants_assertion_signed"></a> [saml\_wants\_assertion\_signed](#input\_saml\_wants\_assertion\_signed) | n/a | `bool` | `true` | no |
| <a name="input_saml_wants_response_authn_signed"></a> [saml\_wants\_response\_authn\_signed](#input\_saml\_wants\_response\_authn\_signed) | n/a | `bool` | `true` | no |
| <a name="input_smtp_auth_pass"></a> [smtp\_auth\_pass](#input\_smtp\_auth\_pass) | n/a | `string` | `null` | no |
| <a name="input_smtp_auth_user"></a> [smtp\_auth\_user](#input\_smtp\_auth\_user) | n/a | `string` | `null` | no |
| <a name="input_smtp_host"></a> [smtp\_host](#input\_smtp\_host) | n/a | `string` | n/a | yes |
| <a name="input_smtp_ip"></a> [smtp\_ip](#input\_smtp\_ip) | n/a | `string` | n/a | yes |
| <a name="input_smtp_port"></a> [smtp\_port](#input\_smtp\_port) | n/a | `string` | `"25"` | no |
| <a name="input_tabnine_address_name"></a> [tabnine\_address\_name](#input\_tabnine\_address\_name) | Name of the address to use for Tabnine ingress | `string` | n/a | yes |
| <a name="input_tabnine_registry_password"></a> [tabnine\_registry\_password](#input\_tabnine\_registry\_password) | n/a | `string` | n/a | yes |
| <a name="input_tabnine_registry_username"></a> [tabnine\_registry\_username](#input\_tabnine\_registry\_username) | n/a | `string` | n/a | yes |
| <a name="input_telemetry_enabled"></a> [telemetry\_enabled](#input\_telemetry\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_tls_cert"></a> [tls\_cert](#input\_tls\_cert) | TLS cert to attach to ingress | `string` | `null` | no |
| <a name="input_tls_key"></a> [tls\_key](#input\_tls\_key) | key used to create the tls cert | `string` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | GCP zones | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
