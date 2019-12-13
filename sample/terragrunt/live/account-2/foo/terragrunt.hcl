terraform {
  source = "../../../modules//composed/network"
}

include {
  path = find_in_parent_folders()
}

locals {
  root_vars    = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("root_vars.yaml")}"))
  account_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("account_vars.yaml")}"))
}

inputs = {
  namespace = "sample"
  stage     = "demo"
  name      = "foo"

  kube_cluster_zones  = [ local.account_vars.foo_blue_kube_cluster, local.account_vars.foo_green_kube_cluster ]
  cidr_block          = "10.200.0.0/20"

  public_additional_subnet_tags = {
    "kubernetes.io/cluster/${local.account_vars.foo_blue_kube_cluster}"  = "shared"
    "kubernetes.io/cluster/${local.account_vars.foo_green_kube_cluster}" = "shared"
    "kubernetes.io/role/elb"                                             = "1"
    "SubnetType"                                                         = "Utility"
  }
  kube_cluster_blue_additional_subnet_tags = {
    "kubernetes.io/cluster/${local.account_vars.foo_blue_kube_cluster}" = "shared"
    "kubernetes.io/role/internal-elb"                                   = "1"
    "SubnetType"                                                        = "Private"
  }
  kube_cluster_green_additional_subnet_tags = {
    "kubernetes.io/cluster/${local.account_vars.foo_green_kube_cluster}" = "shared"
    "kubernetes.io/role/internal-elb"                                    = "1"
    "SubnetType"                                                         = "Private"
  }
}
