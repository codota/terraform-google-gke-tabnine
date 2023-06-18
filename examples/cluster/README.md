# Tabnine Cluster Example

This is an example of managing Tabnine cluster

## Use

`terraform init -from-module=codota/gke-tabnine/google//examples/cluster`

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_exclude_kubernetes_manifest"></a> [exclude\_kubernetes\_manifest](#input\_exclude\_kubernetes\_manifest) | Exclude kubernetes manifest installations. This should be off during initial installation | `bool` | `false` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix all resources names | `string` | `"tabnine-self-hosted"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | GCP zones | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
