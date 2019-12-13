locals {
  id = join("-",list(var.namespace,var.stage,var.name))
  tags = {
      Name      = local.id
      Namespace = var.namespace
      Stage     = var.stage
  }
}

data "aws_region" "current" {}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}

resource "aws_route53_zone" "internal" {
  for_each = toset(var.kube_cluster_zones)
  name     = each.key
  vpc    {
    vpc_id = aws_vpc.main.id
  }

  tags   = local.tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = local.tags
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  tags   = local.tags

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.main.id
}
