# backend.tf
terraform {
  backend "gcs" {
    bucket = "tf-state-basic"
    prefix = "terraform/state"
  }
}