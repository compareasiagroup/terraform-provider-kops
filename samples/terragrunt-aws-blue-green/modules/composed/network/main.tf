locals {
  public_subnets_cidr             = cidrsubnet(module.vpc.cidr_block, 2, 0)
  kube_cluster_blue_subnets_cidr  = cidrsubnet(module.vpc.cidr_block, 2, 1)
  kube_cluster_green_subnets_cidr = cidrsubnet(module.vpc.cidr_block, 2, 2)
  data_subnets_cidr               = cidrsubnet(module.vpc.cidr_block, 2, 3)

  public_subnets_config_map = {
    for az in var.az: az.zone => {
      cidr_block = cidrsubnet(local.public_subnets_cidr, 2, az.number)
      eip        = aws_eip.nat[az.zone]
    }
  }
  kube_cluster_blue_subnets_config_map = {
    for az in var.az: az.zone => {
      cidr_block = cidrsubnet(local.kube_cluster_blue_subnets_cidr, 2, az.number)
    }
  }
  kube_cluster_green_subnets_config_map = {
    for az in var.az: az.zone => {
      cidr_block = cidrsubnet(local.kube_cluster_green_subnets_cidr, 2, az.number)
    }
  }
  data_subnets_config_map = {
    for az in var.az: az.zone => {
      cidr_block = cidrsubnet(local.data_subnets_cidr, 2, az.number)
    }
  }
}

module "vpc" {
  source = "../../basic/vpc"

  namespace = var.namespace
  stage     = var.stage
  name      = var.name

  cidr_block             = var.cidr_block
  kube_cluster_zones     = var.kube_cluster_zones
}

locals {
  id = join("-",list(var.namespace,var.stage,var.name))
  tags = {
    Name      = local.id
    Namespace = var.namespace
    Stage     = var.stage
  }
}

# Provision EIPs for NAT Gateways
resource "aws_eip" "nat" {
  for_each  = toset([for az in var.az: az.zone])
  vpc       = true

  # use the default label.tags, but override name tag to suffix the AZ
  tags = merge(
    local.tags,
    map(
      "Name", "${local.id}-${each.key}",
    )
  )
}

module "public_subnets" {
  source = "../../basic/public-subnets"

  namespace = var.namespace
  stage     = var.stage
  name      = "${var.name}-utilities"

  vpc                    = module.vpc # introduces a tight coupling between these modules
  subnet_config_map      = local.public_subnets_config_map
  additional_subnet_tags = var.public_additional_subnet_tags
}

module "kube_cluster_blue_subnets" {
  source = "../../basic/private-subnets"

  namespace = var.namespace
  stage     = var.stage
  name      = "${var.name}-cluster-blue"

  vpc                           = module.vpc
  public_subnets_map            = module.public_subnets.subnets_map
  subnet_config_map             = local.kube_cluster_blue_subnets_config_map
  additional_subnet_tags        = merge(
    var.kube_cluster_blue_additional_subnet_tags,
    map(
      "Set", "Blue"
    )
  )
}

module "kube_cluster_green_subnets" {
  source = "../../basic/private-subnets"

  namespace = var.namespace
  stage     = var.stage
  name      = "${var.name}-cluster-green"

  vpc                           = module.vpc
  public_subnets_map            = module.public_subnets.subnets_map
  subnet_config_map             = local.kube_cluster_green_subnets_config_map
  additional_subnet_tags        = merge(
    var.kube_cluster_green_additional_subnet_tags,
    map(
      "Set", "Green"
    )
  )
}

module "data_subnets" {
  source = "../../basic/private-subnets"

  namespace = var.namespace
  stage     = var.stage
  name      = "${var.name}-data"

  vpc                           = module.vpc
  public_subnets_map            = module.public_subnets.subnets_map
  subnet_config_map             = local.data_subnets_config_map
  additional_subnet_tags        = var.data_additional_subnet_tags
}

module "kops_state_bucket" {
  source       = "../../basic/s3-bucket-simple"
  namespace    = var.namespace
  stage        = var.stage
  name         = "${var.name}-kstate"
  versioning   = true
}
