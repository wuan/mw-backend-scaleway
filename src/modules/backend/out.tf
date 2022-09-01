// SPDX-FileCopyrightText: 2022 Andreas Wuerl
//
// SPDX-License-Identifier: Apache-2.0

output "public_ip" {
  value = scaleway_instance_server.backend.public_ip
}

output "private_ip" {
  value = scaleway_instance_server.backend.private_ip
}
