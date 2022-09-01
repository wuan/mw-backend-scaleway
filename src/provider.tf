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

/*variable "project_id" {
  type    = string
  default = "ba2b0eb6-2bbd-4e95-b5f1-255f47ada714"
}

provider "scaleway" {
  project_id = var.project_id
}*/



