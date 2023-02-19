# terraform-google-gke-tabnine

This module creates a reslient and fault tolerant Tabnine installation using Google
Kubernetes Engine (GKE) as the computing environment.

![Tabnine on GKE architecture diagram](img/arch.png)

## Prerequistes

- This module uses Nvidia A100 GPU make sure to select a [zone/region](https://cloud.google.com/compute/docs/gpus/gpu-regions-zones) where A100 is available.
- Terraform 1.2.7+
- Install [helm](https://helm.sh/)
- Install [helm-gcs](https://github.com/hayorov/helm-gcs)
- Add Tabnine helm charts repository, **make sure you have read acccess** to `gs://tabnine-self-hosted-helm-charts` provided by Tabnine team

  ```bash
  helm repo add tabnine gs://tabnine-self-hosted-helm-charts
  ```

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

## Usage

There are examples included in the [examples](./examples/) folder but simple usage is as follows:

```hcl
module "gke_tabnine" {
  source                     = "github.com/codota/terraform-google-gke-tabnine"
  project_id                 = "<PROJECT ID>"
  region                     = "<REGION>"
  zones                      = ["<ZONE-1>", "<ZONE-2>"]
  create_vpc                 = true
  create_service_account     = true
}

```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_deny_all_firewall_rules"></a> [create\_deny\_all\_firewall\_rules](#input\_create\_deny\_all\_firewall\_rules) | Should create deny all firewall rules | `bool` | `true` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | Should create a service\_account, or used the one provided by `service_account_email` | `bool` | `false` | no |
| <a name="input_create_tabnine_storage_bucket_im_bindings"></a> [create\_tabnine\_storage\_bucket\_im\_bindings](#input\_create\_tabnine\_storage\_bucket\_im\_bindings) | Create Tabnine storage bucket im bindings. Should be set to true only when run by Tabnine team | `bool` | `false` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Should create a VPC, or used the one provided by `network_name` | `bool` | `false` | no |
| <a name="input_enforce_jwt"></a> [enforce\_jwt](#input\_enforce\_jwt) | Should enforce JWT for user authentication | `bool` | `true` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Configuration of inference engine | <pre>object({<br>    host     = string<br>    internal = bool<br>  })</pre> | `null` | no |
| <a name="input_ip_range_pods"></a> [ip\_range\_pods](#input\_ip\_range\_pods) | Pods ip range, used when `create_vpc` is set to `false` | `string` | `""` | no |
| <a name="input_ip_range_services"></a> [ip\_range\_services](#input\_ip\_range\_services) | Services ip range, used when `create_vpc` is set to `false` | `string` | `""` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | VPC name, used when `create_vpc` is set to `false` | `string` | `""` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | organization ID | `string` | n/a | yes |
| <a name="input_organization_secret"></a> [organization\_secret](#input\_organization\_secret) | Organization Secret | `string` | n/a | yes |
| <a name="input_pre_shared_cert_name"></a> [pre\_shared\_cert\_name](#input\_pre\_shared\_cert\_name) | Use this if you already uploaded a pre-shared cert | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix all resources names | `string` | `"tabnine-self-hosted"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | n/a | yes |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | Service account email, used when `create_service_account` is set to `false` | `string` | `""` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | VPC subnetwork name, used when `create_vpc` is set to `false` | `string` | `""` | no |
| <a name="input_subnetwork_proxy_only"></a> [subnetwork\_proxy\_only](#input\_subnetwork\_proxy\_only) | VPC subnetwork proxy only name, used when `create_vpc` is set to `false` | `string` | `""` | no |
| <a name="input_upload_pre_shared_cert"></a> [upload\_pre\_shared\_cert](#input\_upload\_pre\_shared\_cert) | Use this to upload pre-shared cert | <pre>object({<br>    path_to_private_key = string<br>    path_to_certificate = string<br>  })</pre> | `null` | no |
| <a name="input_use_nvidia_mig"></a> [use\_nvidia\_mig](#input\_use\_nvidia\_mig) | Should use MIG for the GPU (see https://docs.nvidia.com/datacenter/tesla/mig-user-guide/#partitioning) | `bool` | `false` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | GCP zones | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress_ip"></a> [ingress\_ip](#output\_ingress\_ip) | Static IP of inference engine ingress |
<!-- END_TF_DOCS -->

## On first use

- `terraform init` to get the plugins
- `terraform apply -target module.gke_tabnine.module.service_accounts`
  ` to create the service account first
- `terraform apply` to apply everything
