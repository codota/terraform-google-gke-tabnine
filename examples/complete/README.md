# Tabnine Complete Example

This is an example of managing Tabnine cluster with Tabnine installation

## Use

`terraform init --from-module=codota/gke-tabnine/google//examples/complete`

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_managed_cert"></a> [create\_managed\_cert](#input\_create\_managed\_cert) | n/a | `bool` | `false` | no |
| <a name="input_default_email"></a> [default\_email](#input\_default\_email) | n/a | `string` | n/a | yes |
| <a name="input_email_from_field"></a> [email\_from\_field](#input\_email\_from\_field) | n/a | `string` | n/a | yes |
| <a name="input_exclude_kubernetes_manifest"></a> [exclude\_kubernetes\_manifest](#input\_exclude\_kubernetes\_manifest) | Exclude kubernetes manifest installations. This should be off during initial installation | `bool` | `false` | no |
| <a name="input_gke_master_authorized_networks"></a> [gke\_master\_authorized\_networks](#input\_gke\_master\_authorized\_networks) | n/a | <pre>list(object({<br>    cidr_block   = string,<br>    display_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_license_key"></a> [license\_key](#input\_license\_key) | n/a | `string` | n/a | yes |
| <a name="input_organization_domain"></a> [organization\_domain](#input\_organization\_domain) | n/a | `string` | n/a | yes |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | n/a | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | n/a | `string` | n/a | yes |
| <a name="input_organization_secret"></a> [organization\_secret](#input\_organization\_secret) | n/a | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix all resources names | `string` | `"tabnine-self-hosted"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | n/a | yes |
| <a name="input_smtp_auth_pass"></a> [smtp\_auth\_pass](#input\_smtp\_auth\_pass) | n/a | `string` | `null` | no |
| <a name="input_smtp_auth_user"></a> [smtp\_auth\_user](#input\_smtp\_auth\_user) | n/a | `string` | `null` | no |
| <a name="input_smtp_host"></a> [smtp\_host](#input\_smtp\_host) | n/a | `string` | n/a | yes |
| <a name="input_smtp_ip"></a> [smtp\_ip](#input\_smtp\_ip) | n/a | `string` | n/a | yes |
| <a name="input_smtp_port"></a> [smtp\_port](#input\_smtp\_port) | n/a | `string` | `"25"` | no |
| <a name="input_tabnine_address_name"></a> [tabnine\_address\_name](#input\_tabnine\_address\_name) | n/a | `string` | n/a | yes |
| <a name="input_tabnine_registry_password"></a> [tabnine\_registry\_password](#input\_tabnine\_registry\_password) | n/a | `string` | n/a | yes |
| <a name="input_tabnine_registry_username"></a> [tabnine\_registry\_username](#input\_tabnine\_registry\_username) | n/a | `string` | n/a | yes |
| <a name="input_tls_cert_path"></a> [tls\_cert\_path](#input\_tls\_cert\_path) | n/a | `string` | `null` | no |
| <a name="input_tls_key_path"></a> [tls\_key\_path](#input\_tls\_key\_path) | n/a | `string` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | GCP zones | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
