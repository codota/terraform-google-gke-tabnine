module "service_accounts" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "4.2.3"
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

resource "google_service_account" "kms_service_account" {
  account_id   = var.kms_iam_service_account_name
  display_name = "Service account for GKE to access KMS"
}

resource "kubernetes_service_account" "ksa" {
  metadata {
    name      = "${var.kms_kubernetes_service_account_namespace}-kms"
    namespace = var.kms_kubernetes_service_account_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.kms_service_account.email
    }
  }
}

resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = google_service_account.kms_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.kms_kubernetes_service_account_namespace}/${kubernetes_service_account.ksa.metadata.0.name}]"
}

locals {
  kms_roles = ["roles/cloudkms.cryptoKeyEncrypterDecrypter", "roles/cloudkms.viewer", "roles/cloudkms.admin"]
}

resource "google_kms_key_ring_iam_binding" "keyring_roles" {
  for_each = tomap({
    for pair in setproduct(var.encryption_service_kms_keyrings, local.kms_roles) : "${pair[0]}${pair[1]}" => { keyring_key = pair[0], role = pair[1] }
  })

  key_ring_id = google_kms_key_ring.encryption_service_keyring[each.value.keyring_key].id
  role        = each.value.role

  members = [
    "serviceAccount:${google_service_account.kms_service_account.email}"
  ]
}
