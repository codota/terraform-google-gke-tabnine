module "service_accounts" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.0"
  project_id = var.project_id
  prefix     = ""
  names      = [format("%s-gke", var.prefix)]
  project_roles = [
    "${var.project_id}=>roles/logging.logWriter",
    # "${var.project_id}=>roles/logging.bucketWriter",
    "${var.project_id}=>roles/monitoring.metricWriter",
    "${var.project_id}=>roles/cloudkms.cryptoKeyEncrypterDecrypter",
  ]
}
