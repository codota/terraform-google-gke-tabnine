# terraform-google-gke-tabnine

This module creates a reslient and fault tolerant Tabnine installation using Google
Kubernetes Engine (GKE) as the computing environment.

## Prerequistes

- This module uses Nvidia A100 GPU, make sure to select a [zone/region](https://cloud.google.com/compute/docs/gpus/gpu-regions-zones) where A100 is available.
- Install [helm](https://helm.sh/)
- Install [helm-git](https://github.com/aslafy-z/helm-git)
- Add Tabnine helm charts repository 
  ```bash
  helm repo add tabnine https://github.com/codota/helm-charts@charts\?ref=initial-commit
  ```
- Configure `gcloud` to use the right project:

  ```bash
  gcloud config set project <PROJECT ID>
  ```

- Make sure that GKE is enable for the `<PROJECT ID>` you are going to use.

  ```bash
  gcloud services enable container.googleapis.com
  ```

## Compatibility

This module is meant for use with Terraform X and tested using Terraform Y.

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

### On first use

- `terraform init` to get the plugins
- `tf apply -target module.gke_tabnine.module.service_accounts
 ` to create the service account first  
- `tf apply -var exclude_nvidia_driver=true`
   to create infrastructure without nvidia drivers, this is a hack since kubernetes_manfest requires a live kubernetes cluster. (see https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest#before-you-use-this-resource)
   can be solved later by migrating to `kubernetes_daemonset`
- `terraform apply` to apply everything
