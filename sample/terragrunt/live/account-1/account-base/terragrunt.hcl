terraform {
  source = "../../../modules//composed/account-base"
}

include {
  path = find_in_parent_folders()
}

locals {
  root_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("root_vars.yaml")}"))
}

inputs = {
  namespace          = "sample"
  stage              = "demo"
  name               = "account-1"
  public_zones       = {
    "${local.root_vars.foo_dns}" = {
      parent           = local.root_vars.root_dns
      trusted_accounts = {
        account-2 = local.root_vars.accounts["account-2"]
      }
    },
  }
}
