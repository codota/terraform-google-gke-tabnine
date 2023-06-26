# Tabnine Cluster Example

This is an example of managing Tabnine cluster

## Use

`terraform init -from-module=codota/gke-tabnine/google//examples/cluster`

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke_cluster_tabnine"></a> [gke\_cluster\_tabnine](#module\_gke\_cluster\_tabnine) | codota/gke-tabnine/google//modules/cluster | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_exclude_kubernetes_manifest"></a> [exclude\_kubernetes\_manifest](#input\_exclude\_kubernetes\_manifest) | Exclude kubernetes manifest installations. This should be off during initial installation | `bool` | `false` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix all resources names | `string` | `"tabnine-self-hosted"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | GCP zones | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_certificate"></a> [ca\_certificate](#output\_ca\_certificate) | Cluster ca certificate (base64 encoded) |
| <a name="output_db_ca_base64"></a> [db\_ca\_base64](#output\_db\_ca\_base64) | Database ca certificate (base64 encoded) |
| <a name="output_db_cert_base64"></a> [db\_cert\_base64](#output\_db\_cert\_base64) | Database server cert certificate (base64 encoded) |
| <a name="output_db_private_key_base64"></a> [db\_private\_key\_base64](#output\_db\_private\_key\_base64) | Database client private key (base64 encoded) |
| <a name="output_db_url"></a> [db\_url](#output\_db\_url) | n/a |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Cluster endpoint |
| <a name="output_redis_ca_base64"></a> [redis\_ca\_base64](#output\_redis\_ca\_base64) | n/a |
| <a name="output_redis_url"></a> [redis\_url](#output\_redis\_url) | n/a |
<!-- END_TF_DOCS -->
