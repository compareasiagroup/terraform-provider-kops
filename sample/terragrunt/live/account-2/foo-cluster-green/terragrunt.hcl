terraform {
  source = "../../../modules//composed/kops-cluster"
}

include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../foo"
}

locals {
  root_vars    = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("root_vars.yaml")}"))
  account_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("account_vars.yaml")}"))
}

inputs = {
  namespace             = "sample"
  stage                 = "demo"
  name                  = "foo-green-kops"
  state_store           = "s3://${dependency.network.outputs.kops_state_bucket.id}" # state store has to exist
  cluster_name          = local.account_vars.foo_green_kube_cluster
  vpc                   = dependency.network.outputs.vpc
  utility_subnets       = dependency.network.outputs.public_subnets.subnets_map
  node_subnets          = dependency.network.outputs.kube_cluster_green_subnets.subnets_map

  # sample of centralized DNS zones
  extdns_zones          = [
    dependency.network.outputs.internal_zones[local.account_vars.foo_green_kube_cluster],
  ]

  master_roles          = [
    "arn:aws:iam::${local.root_vars.accounts["account-1"]}:role/externaldns.${local.root_vars.foo_dns}",
  ]

  allowed_cidr_blocks   = [ ]
}
