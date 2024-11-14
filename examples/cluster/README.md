# Tabnine Cluster Example

This is an example of managing Tabnine cluster

## Use

`terraform init -from-module=codota/gke-tabnine/google//examples/cluster`

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_exclude_kubernetes_manifest"></a> [exclude\_kubernetes\_manifest](#input\_exclude\_kubernetes\_manifest) | Exclude kubernetes manifest installations. This should be off during initial installation | `bool` | `false` | no |
| <a name="input_gke_master_authorized_networks"></a> [gke\_master\_authorized\_networks](#input\_gke\_master\_authorized\_networks) | n/a | <pre>list(object({<br>    cidr_block   = string,<br>    display_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_kms_iam_service_account_name"></a> [kms\_iam\_service\_account\_name](#input\_kms\_iam\_service\_account\_name) | The name of the IAM service account for using kms | `string` | n/a | yes |
| <a name="input_kms_kubernetes_service_account_namespace"></a> [kms\_kubernetes\_service\_account\_namespace](#input\_kms\_kubernetes\_service\_account\_namespace) | The kubernetes namespace where the kms service account resides | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix all resources names | `string` | `"tabnine-self-hosted"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | GCP zones | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_ca_base64"></a> [db\_ca\_base64](#output\_db\_ca\_base64) | Database ca certificate (base64 encoded) |
| <a name="output_db_cert_base64"></a> [db\_cert\_base64](#output\_db\_cert\_base64) | Database server certificate (base64 encoded) |
| <a name="output_db_private_key_base64"></a> [db\_private\_key\_base64](#output\_db\_private\_key\_base64) | Database client private key (base64 encoded) |
| <a name="output_db_url"></a> [db\_url](#output\_db\_url) | n/a |
| <a name="output_ingress_ip"></a> [ingress\_ip](#output\_ingress\_ip) | IP address of the Ingress controller |
| <a name="output_redis_ca_base64"></a> [redis\_ca\_base64](#output\_redis\_ca\_base64) | n/a |
| <a name="output_redis_url"></a> [redis\_url](#output\_redis\_url) | n/a |
<!-- END_TF_DOCS -->
