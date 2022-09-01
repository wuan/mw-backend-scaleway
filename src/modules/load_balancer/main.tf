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

resource "scaleway_lb" "base" {
  name = "${var.prefix}magic-wormhole-backend"
  ip_id = var.balancer_ip_id
  zone  = var.balancer_zone
  type  = var.balancer_type
}

resource scaleway_lb_backend mailbox {
  name = "${var.prefix}backend-mailbox"
  lb_id            = scaleway_lb.base.id
  forward_protocol = "tcp"
  forward_port     = 4000
  proxy_protocol   = "none"
  server_ips       = [var.private_backend_ip]
}

resource scaleway_lb_backend relay {
  name = "${var.prefix}backend-relay"
  lb_id            = scaleway_lb.base.id
  forward_protocol = "tcp"
  forward_port     = 4001
  proxy_protocol   = "none"
  server_ips       = [var.private_backend_ip]
}

resource scaleway_lb_backend relay_ws {
  name = "${var.prefix}backend-relay-ws"
  lb_id            = scaleway_lb.base.id
  forward_protocol = "tcp"
  forward_port     = 4002
  proxy_protocol   = "none"
  server_ips       = [var.private_backend_ip]
}

resource scaleway_lb_frontend mailbox_tls {
  name = "${var.prefix}frontend-mailbox-tls"
  lb_id           = scaleway_lb.base.id
  backend_id      = scaleway_lb_backend.mailbox.id
  inbound_port    = 443
  certificate_ids = [scaleway_lb_certificate.relay.id]
}

resource scaleway_lb_frontend mailbox {
  name = "${var.prefix}frontend-mailbox"
  lb_id        = scaleway_lb.base.id
  backend_id   = scaleway_lb_backend.mailbox.id
  inbound_port = 4000
}

resource scaleway_lb_frontend relay {
  name = "${var.prefix}frontend-relay"
  lb_id        = scaleway_lb.base.id
  backend_id   = scaleway_lb_backend.relay.id
  inbound_port = 4001
}

resource scaleway_lb_route relay_ws {
  frontend_id = scaleway_lb_frontend.mailbox_tls.id
  backend_id  = scaleway_lb_backend.relay_ws.id
  match_sni   = "relay.${var.domain_name}"
}

resource scaleway_lb_route mailbox {
  frontend_id = scaleway_lb_frontend.mailbox_tls.id
  backend_id  = scaleway_lb_backend.mailbox.id
  match_sni   = "mailbox.${var.domain_name}"
}

resource scaleway_lb_certificate mailbox {
  lb_id = scaleway_lb.base.id
  name  = "${var.prefix}mailbox"
  letsencrypt {
    common_name = "mailbox.${var.domain_name}"
  }
}

resource scaleway_lb_certificate relay {
  lb_id = scaleway_lb.base.id
  name  = "${var.prefix}relay"
  letsencrypt {
    common_name = "relay.${var.domain_name}"
  }
}
