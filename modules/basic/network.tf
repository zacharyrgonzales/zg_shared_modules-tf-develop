# VPC and Subnets
module "vpc-host-dev" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.vpc-host-dev-project.project_id
  network_name = "vpc-host-dev"

  subnets = [

    {
      subnet_name               = "subnet-dev-1"
      subnet_ip                 = "10.1.0.0/24"
      subnet_region             = "us-central1"
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.5"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
    },
    {
      subnet_name               = "subnet-dev-2"
      subnet_ip                 = "10.2.0.0/24"
      subnet_region             = "us-east1"
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.5"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
    },
  ]
}
# Firewall Rules
resource "google_compute_firewall" "vpc-host-dev-allow-iap-rdp" {
  name      = "vpc-host-dev-allow-iap-rdp"
  network   = module.vpc-host-dev.network_name
  project   = module.vpc-host-dev-project.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["3389", ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}
resource "google_compute_firewall" "vpc-host-dev-allow-iap-ssh" {
  name      = "vpc-host-dev-allow-iap-ssh"
  network   = module.vpc-host-dev.network_name
  project   = module.vpc-host-dev-project.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
}
resource "google_compute_firewall" "vpc-host-dev-allow-icmp" {
  name      = "vpc-host-dev-allow-icmp"
  network   = module.vpc-host-dev.network_name
  project   = module.vpc-host-dev-project.project_id
  direction = "INGRESS"
  priority  = 10000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "10.128.0.0/9",
  ]
}
# NAT Router and config
resource "google_compute_router" "rt-vpc-host-dev-1000-egress-internet-default" {
  name    = "rt-vpc-host-dev-1000-egress-internet-default"
  project = module.vpc-host-dev-project.project_id
  region  = "us-central1"
  network = module.vpc-host-dev.network_self_link
}