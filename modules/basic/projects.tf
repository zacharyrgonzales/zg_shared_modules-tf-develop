resource "random_id" "project" {
  byte_length = 4
}

module "vpc-host-dev-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "vpc-host-dev"
  project_id = "vpc-host-dev-${random_id.project.hex}"
  org_id     = var.org_id
  folder_id  = google_folder.development.name

  billing_account = var.billing_account
}