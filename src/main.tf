resource "scaleway_instance_ip" "backend_server" {
}

resource "scaleway_lb_ip" "main" {
  zone = "fr-par-1"
}

module "dns-setup" {
  source = "./modules/dns"
  domain_name = var.base_domain_name
  backend_server_ip = scaleway_instance_ip.backend_server.address
  load_balancer_ip = scaleway_lb_ip.main.ip_address
}

module "backend_server" {
  source = "./modules/backend"
  public_ip_id = scaleway_instance_ip.backend_server.id
}

module "load_balancer" {
  source = "./modules/load_balancer"
  domain_name = var.base_domain_name
  balancer_ip_id = scaleway_lb_ip.main.id
  balancer_zone = scaleway_lb_ip.main.zone
  private_backend_ip = module.backend_server.private_ip
}

output "server_ip" {
  value = scaleway_instance_ip.backend_server.address
}