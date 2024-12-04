locals {
 auth_type = var.auth_type
}

module "auth_iam" {
 source   = "./auth_iam"
 count    = local.auth_type == "iam" ? 1 : 0
}

module "auth_key" {
 source   = "./auth_key"
 count    = local.auth_type == "key" ? 1 : 0
}

