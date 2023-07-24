# Tabnine Cluster Module

This module is used to create Tabnine Cluster.

## Prerequistes

- This module uses Nvidia A100 GPU make sure to select a [zone/region](https://cloud.google.com/compute/docs/gpus/gpu-regions-zones) where A100 is available.
- Terraform 1.2.3+
- Install [helm](https://helm.sh/)
- Configure `gcloud` to use the right project:

  ```bash
  gcloud config set project <PROJECT ID>
  ```

- Enable the following google apis for the `<PROJECT ID>`:

  ```bash
  gcloud services enable container.googleapis.com
  gcloud services enable servicedirectory.googleapis.com
  gcloud services enable dns.googleapis.com
  ```

- Log in with a user that has `Editor` & `Project IAM Admin` roles.

## Use

```hcl
module "gke_cluster_tabnine" {
  source                                    = "terraform-google-gke-tabnine//modules/cluster/"
  project_id                                = "<PROJECT-ID>"
  region                                    = "<REGION>"
  zones                                     = "<ZONES>"
  prefix                                    = "<PREFIX>"
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_tabnine_storage_bucket_im_bindings"></a> [create\_tabnine\_storage\_bucket\_im\_bindings](#input\_create\_tabnine\_storage\_bucket\_im\_bindings) | Create Tabnine storage bucket im bindings. Should be set to true only when run by Tabnine team | `bool` | `false` | no |
| <a name="input_db_master_zone"></a> [db\_master\_zone](#input\_db\_master\_zone) | Database master zone. If not set, will default to first zone | `string` | `null` | no |
| <a name="input_exclude_kubernetes_manifest"></a> [exclude\_kubernetes\_manifest](#input\_exclude\_kubernetes\_manifest) | Exclude kubernetes manifest installations. This should be off during initial installation | `bool` | `false` | no |
| <a name="input_min_gpu_machines"></a> [min\_gpu\_machines](#input\_min\_gpu\_machines) | Minimum number of GPU instances | `number` | `1` | no |
| <a name="input_pre_shared_cert_name"></a> [pre\_shared\_cert\_name](#input\_pre\_shared\_cert\_name) | Use this if you already uploaded a pre-shared cert | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix all resources names | `string` | `"tabnine-self-hosted"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | n/a | yes |
| <a name="input_use_nvidia_mig"></a> [use\_nvidia\_mig](#input\_use\_nvidia\_mig) | Should use MIG for the GPU (see https://docs.nvidia.com/datacenter/tesla/mig-user-guide/#partitioning) | `bool` | `false` | no |
| <a name="input_use_spot_instances"></a> [use\_spot\_instances](#input\_use\_spot\_instances) | Should use spot instances | `bool` | `false` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | GCP zones | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_certificate"></a> [ca\_certificate](#output\_ca\_certificate) | Cluster ca certificate (base64 encoded) |
| <a name="output_db_ca"></a> [db\_ca](#output\_db\_ca) | n/a |
| <a name="output_db_cert"></a> [db\_cert](#output\_db\_cert) | n/a |
| <a name="output_db_ip"></a> [db\_ip](#output\_db\_ip) | n/a |
| <a name="output_db_private_key"></a> [db\_private\_key](#output\_db\_private\_key) | n/a |
| <a name="output_db_url"></a> [db\_url](#output\_db\_url) | n/a |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Cluster endpoint |
| <a name="output_redis_ca"></a> [redis\_ca](#output\_redis\_ca) | n/a |
| <a name="output_redis_ip"></a> [redis\_ip](#output\_redis\_ip) | n/a |
| <a name="output_redis_url"></a> [redis\_url](#output\_redis\_url) | n/a |
<!-- END_TF_DOCS -->
