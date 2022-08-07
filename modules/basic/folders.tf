resource "google_folder" "development" {
  display_name = "Development"
  parent       = "organizations/${var.org_id}"
}

