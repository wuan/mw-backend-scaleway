variable "domain_name" {
  type = string
  description = "subdomain to be used"
}

variable "backend_server_ip" {
  type = string
  description = "IP address of the backend server"
}

variable "load_balancer_ip" {
  type = string
  description = "IP address of the load_balancer"
}
