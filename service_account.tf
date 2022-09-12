module "service_accounts" {
  count      = var.create_service_account ? 1 : 0
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 2.0"
  project_id = var.project_id
  prefix     = ""
  names      = [format("%s-gke", var.prefix)]
  project_roles = [
    "${var.project_id}=>roles/logging.logWriter",
    "${var.project_id}=>roles/logging.bucketWriter",
    "${var.project_id}=>roles/storage.objectAdmin",
    "train-tabnine-small=>roles/storage.objectAdmin",
  ]
}
