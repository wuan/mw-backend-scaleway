// SPDX-FileCopyrightText: 2022 Andreas Wuerl
//
// SPDX-License-Identifier: Apache-2.0

variable "public_ip_id" {
  type = string
  description = "public ip of server"
}

variable "tags" {
  default = []
  description = "Tags to be applied to the created resources"
}

variable "prefix" {
  default = ""
  description = "name prefix for the created resources"
}