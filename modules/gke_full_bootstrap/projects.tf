resource "random_id" "project" {
  byte_length = 4
}

module "logging-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "logging"
  project_id = "logging-${random_id.project.hex}"
  org_id     = var.org_id
  folder_id  = google_folder.common.name

  billing_account = var.billing_account
}

module "monitoring-dev-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "monitoring-dev"
  project_id = "monitoring-dev-${random_id.project.hex}"
  org_id     = var.org_id
  folder_id  = google_folder.common.name

  billing_account = var.billing_account
}

module "monitoring-nonprod-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "monitoring-nonprod"
  project_id = "monitoring-nonprod-${random_id.project.hex}"
  org_id     = var.org_id
  folder_id  = google_folder.common.name

  billing_account = var.billing_account
}

module "monitoring-prod-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "monitoring-prod"
  project_id = "monitoring-prod-${random_id.project.hex}"
  org_id     = var.org_id
  folder_id  = google_folder.common.name

  billing_account = var.billing_account
}

module "vpc-host-dev-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "vpc-host-dev"
  project_id = "vpc-host-dev-${random_id.project.hex}"
  org_id     = var.org_id
  folder_id  = google_folder.common.name

  billing_account = var.billing_account
}

module "vpc-host-nonprod-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "vpc-host-nonprod"
  project_id = "vpc-host-nonprod-${random_id.project.hex}"
  org_id     = var.org_id
  folder_id  = google_folder.common.name

  billing_account = var.billing_account
}

module "vpc-host-prod-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 12.0"

  name       = "vpc-host-prod"
  project_id = "vpc-host-prod-${random_id.project.hex}"
  org_id     = var.org_id
  folder_id  = google_folder.common.name

  billing_account = var.billing_account
}
