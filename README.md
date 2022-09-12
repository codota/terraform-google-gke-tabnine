# terraform-google-gke-tabnine

```hcl
module "gke-tabnine" {
  source                     = "github.com:codota/terraform-google-gke-tabnine"
  project_id                 = "<PROJECT ID>"
  region                     = "<REGION>"
  zones                      = ["<ZONE-1>", "<ZONE-2>"]
  create_vpc                 = true
  create_service_account     = true
}
```
