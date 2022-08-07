# backend.tf
terraform {
  backend "gcs" {
    bucket = "tf-state-onboarding-foundation"
    prefix = "terraform/state"
  }
}