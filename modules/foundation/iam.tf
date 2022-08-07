module "organization-iam" {
  source  = "terraform-google-modules/iam/google//modules/organizations_iam"
  version = "~> 7.4"

  organizations = ["${ORG_ID}"]

  bindings = {

    "roles/billing.admin" = [
      "group:gcp-billing-admins@${var.org_name}",
    ]

    "roles/resourcemanager.organizationAdmin" = [
      "group:gcp-organization-admins@${var.org_name}",
    ]

  }
}
