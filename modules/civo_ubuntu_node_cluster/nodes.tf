# Query small instance size
data "civo_size" "medium" {
  filter {
    key    = "name"
    values = ["g3.medium"]
  }

  filter {
    key    = "type"
    values = ["instance"]
  }

}

# Query instance disk image
data "civo_disk_image" "ubuntu" {
  filter {
    key    = "version"
    values = ["20.04"]
  }
}

# Create a firewall
resource "civo_firewall" "my-firewall" {
  name = "my-firewall"
}

# Create a firewall rule
resource "civo_firewall_rule" "ssh" {
  firewall_id = civo_firewall.my-firewall.id
  protocol    = "tcp"
  start_port  = "22"
  end_port    = "22"
  cidr        = [var.my_public_ip]
  direction   = "ingress"
  label       = "ssh"
  action      = "allow"
}

# Create a new control planeinstance
resource "civo_instance" "control-plane" {
  hostname    = "control-plane"
  tags        = ["control-plane"]
  notes       = "control plane node for ckad"
  size        = element(data.civo_size.medium.sizes, 0).name
  disk_image  = element(data.civo_disk_image.ubuntu.diskimages, 0).id
  firewall_id = civo_firewall.my-firewall.id
  script      = "scripts/k8scp.sh"
}

# Create a new worker instance
resource "civo_instance" "worker" {
  hostname    = "worker"
  tags        = ["worker"]
  notes       = "worker node for ckad"
  size        = element(data.civo_size.medium.sizes, 0).name
  disk_image  = element(data.civo_disk_image.ubuntu.diskimages, 0).id
  firewall_id = civo_firewall.my-firewall.id
  script      = "scripts/k8sWorker.sh"
}