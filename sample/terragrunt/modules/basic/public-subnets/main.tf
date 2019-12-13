locals {
  id = join("-",list(var.namespace,var.stage,var.name))
  tags = {
      Name      = local.id
      Namespace = var.namespace
      Stage     = var.stage
  }
}

resource "aws_subnet" "main" {
  for_each                 = var.subnet_config_map
  vpc_id                   = var.vpc.vpc_id
  availability_zone        = each.key
  cidr_block               = each.value.cidr_block
  map_public_ip_on_launch  = true

  # use the default label.tags, but override name tag to prefix the AZ
  tags = merge(
    local.tags,
    map(
      "Name", "${local.id}-public-${each.key}"
    ),
    var.additional_subnet_tags,
  )
}

resource "aws_nat_gateway" "main" {
  for_each      = var.subnet_config_map
  allocation_id = each.value.eip.id
  subnet_id     = aws_subnet.main[each.key].id

  # use the default label.tags, but override name tag to suffix the AZ
  tags = merge(
    local.tags,
    map(
      "Name", "${local.id}-${each.key}"
    )
  )
}
