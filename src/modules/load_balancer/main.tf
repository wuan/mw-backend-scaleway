terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

resource "scaleway_lb" "base" {
  ip_id = var.balancer_ip_id
  zone  = var.balancer_zone
  type  = var.balancer_type
}

resource scaleway_lb_backend mailbox {
  lb_id            = scaleway_lb.base.id
  forward_protocol = "tcp"
  forward_port     = 4000
  proxy_protocol   = "none"
  server_ips       = [var.private_backend_ip]
}

resource scaleway_lb_backend relay {
  lb_id            = scaleway_lb.base.id
  forward_protocol = "tcp"
  forward_port     = 4001
  proxy_protocol   = "none"
  server_ips       = [var.private_backend_ip]
}

resource scaleway_lb_backend relay_ws {
  lb_id            = scaleway_lb.base.id
  forward_protocol = "tcp"
  forward_port     = 4002
  proxy_protocol   = "none"
  server_ips       = [var.private_backend_ip]
}

resource scaleway_lb_frontend ssl {
  lb_id           = scaleway_lb.base.id
  backend_id      = scaleway_lb_backend.mailbox.id
  inbound_port    = 443
  certificate_ids = [scaleway_lb_certificate.relay.id]
}

resource scaleway_lb_frontend mailbox {
  lb_id        = scaleway_lb.base.id
  backend_id   = scaleway_lb_backend.mailbox.id
  inbound_port = 4000
}

resource scaleway_lb_frontend relay {
  lb_id        = scaleway_lb.base.id
  backend_id   = scaleway_lb_backend.relay.id
  inbound_port = 4001
}

resource scaleway_lb_route relay {
  frontend_id = scaleway_lb_frontend.ssl.id
  backend_id  = scaleway_lb_backend.relay_ws.id
  match_sni   = "relay.${var.domain_name}"
}

resource scaleway_lb_route mailbox {
  frontend_id = scaleway_lb_frontend.ssl.id
  backend_id  = scaleway_lb_backend.mailbox.id
  match_sni   = "mailbox.${var.domain_name}"
}

resource scaleway_lb_certificate mailbox {
  lb_id = scaleway_lb.base.id
  name  = "mailbox"
  letsencrypt {
    common_name = "mailbox.${var.domain_name}"
  }
}

resource scaleway_lb_certificate relay {
  lb_id = scaleway_lb.base.id
  name  = "relay"
  letsencrypt {
    common_name = "relay.${var.domain_name}"
  }
}
