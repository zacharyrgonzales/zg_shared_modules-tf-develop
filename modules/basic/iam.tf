module "organization-iam" {
  source  = "terraform-google-modules/iam/google//modules/organizations_iam"
  version = "~> 7.4"

  organizations = [var.org_id]

  bindings = {

    "roles/billing.admin" = [
      "group:gcp-billing-admins@${var.org_id}",
    ]

    "roles/resourcemanager.organizationAdmin" = [
      "group:gcp-organization-admins@${var.org_id}",
    ]

  }
}
