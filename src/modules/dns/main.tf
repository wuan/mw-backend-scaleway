// SPDX-FileCopyrightText: 2022 Andreas Wuerl
//
// SPDX-License-Identifier: Apache-2.0

terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

data "scaleway_domain_zone" "root" {
  domain    = var.domain_name
  subdomain = ""
}

resource "scaleway_domain_record" "relay" {
  data     = var.load_balancer_ip
  dns_zone = data.scaleway_domain_zone.root.id
  name     = "relay"
  type     = "A"
}

resource "scaleway_domain_record" "mailbox" {
  data     = var.load_balancer_ip
  dns_zone = data.scaleway_domain_zone.root.id
  name     = "mailbox"
  type     = "A"
}

resource "scaleway_domain_record" "server" {
  data     = var.backend_server_ip
  dns_zone = data.scaleway_domain_zone.root.id
  name     = ""
  type     = "A"
}
