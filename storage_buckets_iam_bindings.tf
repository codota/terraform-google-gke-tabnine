module "storage_buckets_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/storage_buckets_iam"
  version = "~> 6.4"

  storage_buckets = ["tabnine-training-pipeline", "artifacts.tabnine-self-hosted.appspot.com"]

  mode = "additive"

  bindings = {
    "roles/storage.legacyBucketReader" = [
      format("serviceAccount:%s", local.service_account_email)
    ],
    "roles/storage.objectViewer" = [
      format("serviceAccount:%s", local.service_account_email)
    ],
  }
}

