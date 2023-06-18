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

| Name                                                                                                                                                         | Description                                                                                            | Type                                                                                                                                                                                                           | Default                                                 | Required |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- | :------: |
| <a name="input_create_tabnine_storage_bucket_im_bindings"></a> [create_tabnine_storage_bucket_im_bindings](#input_create_tabnine_storage_bucket_im_bindings) | Create Tabnine storage bucket im bindings. Should be set to true only when run by Tabnine team         | `bool`                                                                                                                                                                                                         | `false`                                                 |    no    |
| <a name="input_db_master_zone"></a> [db_master_zone](#input_db_master_zone)                                                                                  | Database master zone. If not set, will default to first zone                                           | `string`                                                                                                                                                                                                       | `null`                                                  |    no    |
| <a name="input_exclude_kubernetes_manifest"></a> [exclude_kubernetes_manifest](#input_exclude_kubernetes_manifest)                                           | Exclude kubernetes manifest installations. This should be off during initial installation              | `bool`                                                                                                                                                                                                         | `false`                                                 |    no    |
| <a name="input_firewall_rules"></a> [firewall_rules](#input_firewall_rules)                                                                                  | Egress firewall rules configuration                                                                    | <pre>object({<br> deny_all = bool<br> allow = list(object({<br> name = string<br> ranges = list(string)<br> ports = list(object({<br> number = list(string)<br> protocol = string<br> }))<br> }))<br> })</pre> | <pre>{<br> "allow": [],<br> "deny_all": true<br>}</pre> |    no    |
| <a name="input_min_gpu_machines"></a> [min_gpu_machines](#input_min_gpu_machines)                                                                            | Minimum number of GPU instances                                                                        | `number`                                                                                                                                                                                                       | `1`                                                     |    no    |
| <a name="input_pre_shared_cert_name"></a> [pre_shared_cert_name](#input_pre_shared_cert_name)                                                                | Use this if you already uploaded a pre-shared cert                                                     | `string`                                                                                                                                                                                                       | `null`                                                  |    no    |
| <a name="input_prefix"></a> [prefix](#input_prefix)                                                                                                          | Prefix all resources names                                                                             | `string`                                                                                                                                                                                                       | `"tabnine-self-hosted"`                                 |    no    |
| <a name="input_project_id"></a> [project_id](#input_project_id)                                                                                              | GCP project ID                                                                                         | `string`                                                                                                                                                                                                       | n/a                                                     |   yes    |
| <a name="input_region"></a> [region](#input_region)                                                                                                          | GCP region                                                                                             | `string`                                                                                                                                                                                                       | n/a                                                     |   yes    |
| <a name="input_use_nvidia_mig"></a> [use_nvidia_mig](#input_use_nvidia_mig)                                                                                  | Should use MIG for the GPU (see https://docs.nvidia.com/datacenter/tesla/mig-user-guide/#partitioning) | `bool`                                                                                                                                                                                                         | `false`                                                 |    no    |
| <a name="input_use_spot_instances"></a> [use_spot_instances](#input_use_spot_instances)                                                                      | Should use spot instances                                                                              | `bool`                                                                                                                                                                                                         | `false`                                                 |    no    |
| <a name="input_zones"></a> [zones](#input_zones)                                                                                                             | GCP zones                                                                                              | `list(string)`                                                                                                                                                                                                 | n/a                                                     |   yes    |

## Outputs

| Name                                                                          | Description                             |
| ----------------------------------------------------------------------------- | --------------------------------------- |
| <a name="output_ca_certificate"></a> [ca_certificate](#output_ca_certificate) | Cluster ca certificate (base64 encoded) |
| <a name="output_db_ca"></a> [db_ca](#output_db_ca)                            | n/a                                     |
| <a name="output_db_cert"></a> [db_cert](#output_db_cert)                      | n/a                                     |
| <a name="output_db_private_key"></a> [db_private_key](#output_db_private_key) | n/a                                     |
| <a name="output_db_url"></a> [db_url](#output_db_url)                         | n/a                                     |
| <a name="output_endpoint"></a> [endpoint](#output_endpoint)                   | Cluster endpoint                        |
| <a name="output_redis_ca"></a> [redis_ca](#output_redis_ca)                   | n/a                                     |
| <a name="output_redis_url"></a> [redis_url](#output_redis_url)                | n/a                                     |

<!-- END_TF_DOCS -->
