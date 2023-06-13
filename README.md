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

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## On first use

- `terraform init` to get the plugins
- `terraform apply -target module.gke_tabnine.module.service_accounts`
  ` to create the service account first
-  `terraform apply -var exclude_kubernetes_manifest=true` to exclude kubernetes_manifest while kuberentes is not ready
- `terraform apply` to apply everything
- `terraform output -json` to get ingress ip & default password
