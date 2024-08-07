module "storage_buckets_iam_bindings" {
  count   = var.create_tabnine_storage_bucket_im_bindings ? 1 : 0
  source  = "terraform-google-modules/iam/google//modules/storage_buckets_iam"
  version = "7.7.1"

  storage_buckets = ["tabnine-self-hosted-models", "artifacts.tabnine-self-hosted.appspot.com"]

  mode = "additive"

  bindings = {
    "roles/storage.legacyBucketReader" = [
      format("serviceAccount:%s", module.service_accounts.service_account.email)
    ],
    "roles/storage.objectViewer" = [
      format("serviceAccount:%s", module.service_accounts.service_account.email)
    ],
  }
}

