module "logsink-logbucketsink" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.3.0"

  destination_uri      = module.zacharygonzales-logging-destination.destination_uri
  log_sink_name        = "${var.org_id}-logbucketsink"
  parent_resource_id   = var.org_id
  parent_resource_type = "organization"
  include_children     = true
}

module "zacharygonzales-logging-destination" {
  source  = "terraform-google-modules/log-export/google//modules/logbucket"
  version = "~> 7.4.1"

  project_id               = module.vpc-host-dev-project.project_id
  name                     = "zacharygonzales-logging"
  location                 = "global"
  retention_days           = 365
  log_sink_writer_identity = module.logsink-logbucketsink.writer_identity
}
