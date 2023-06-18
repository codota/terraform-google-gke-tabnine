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
| <a name="input_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#input\_cluster\_ca\_certificate) | n/a | `string` | n/a | yes |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | n/a | `string` | n/a | yes |
| <a name="input_db_ca"></a> [db\_ca](#input\_db\_ca) | n/a | `string` | n/a | yes |
| <a name="input_db_cert"></a> [db\_cert](#input\_db\_cert) | n/a | `string` | n/a | yes |
| <a name="input_db_private_key"></a> [db\_private\_key](#input\_db\_private\_key) | n/a | `string` | n/a | yes |
| <a name="input_db_url"></a> [db\_url](#input\_db\_url) | n/a | `string` | n/a | yes |
| <a name="input_default_email"></a> [default\_email](#input\_default\_email) | n/a | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_exclude_kubernetes_manifest"></a> [exclude\_kubernetes\_manifest](#input\_exclude\_kubernetes\_manifest) | Exclude kubernetes manifest installations. This should be off during initial installation | `bool` | `false` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | n/a | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | n/a | `string` | n/a | yes |
| <a name="input_organization_secret"></a> [organization\_secret](#input\_organization\_secret) | n/a | `string` | n/a | yes |
| <a name="input_pre_shared_cert_name"></a> [pre\_shared\_cert\_name](#input\_pre\_shared\_cert\_name) | n/a | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix all resources names | `string` | `"tabnine-self-hosted"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_redis_ca"></a> [redis\_ca](#input\_redis\_ca) | n/a | `string` | n/a | yes |
| <a name="input_redis_url"></a> [redis\_url](#input\_redis\_url) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | GCP zones | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
