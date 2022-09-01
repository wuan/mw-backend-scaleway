terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

resource "scaleway_instance_volume" "data" {
  name = "${var.prefix}magic-wormhole-data"
  size_in_gb = 40
  type       = "l_ssd"
}

resource "scaleway_instance_security_group" "server" {
  name = "${var.prefix}magic-wormhole-backend"
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action = "accept"
    port   = "4000"
  }

  inbound_rule {
    action = "accept"
    port   = "4001"
  }

  inbound_rule {
    action = "accept"
    port   = "4002"
  }

  inbound_rule {
    action = "accept"
    port   = "22"
  }
}

resource "scaleway_instance_server" "backend" {
  name       = "${var.prefix}magic-wormhole-backend"
  type       = "DEV1-L"
  image      = "ubuntu_jammy"

  tags = var.tags

  ip_id = var.public_ip_id

  additional_volume_ids = [scaleway_instance_volume.data.id]

  root_volume {
    # The local storage of a DEV1-L instance is 80 GB, subtract 30 GB from the additional l_ssd volume, then the root volume needs to be 50 GB.
    size_in_gb = 40
  }

  cloud_init        = file("${path.module}/cloud-init.yml")
  security_group_id = scaleway_instance_security_group.server.id
}
