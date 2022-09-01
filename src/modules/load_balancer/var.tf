// SPDX-FileCopyrightText: 2022 Andreas Wuerl
//
// SPDX-License-Identifier: Apache-2.0

variable "balancer_ip_id" {
  type = string
  description = "IP address of the load balancer"
}

variable "balancer_zone" {
  type = string
  description = "Zone of the load balancer"
}

variable "balancer_type" {
  default = "LB-S"
  description = "Type of the load balancer"
}

variable "private_backend_ip" {
  type = string
  description = "private IP address of backend server"
}

variable "domain_name" {
  type = string
  description = "subdomain to be used"
}

variable "tags" {
  default = []
  description = "Tags to be applied to the created resources"
}

variable "prefix" {
  default = ""
  description = "name prefix for the created resources"
}
