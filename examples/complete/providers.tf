terraform {
  backend "gcs" {
    bucket = "tabnine-tf-state"
    prefix = "assaf-self-hosted-0"
  }
}
