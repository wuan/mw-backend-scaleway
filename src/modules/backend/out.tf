output "public_ip" {
  value = scaleway_instance_server.backend.public_ip
}

output "private_ip" {
  value = scaleway_instance_server.backend.private_ip
}
