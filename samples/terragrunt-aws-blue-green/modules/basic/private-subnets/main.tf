locals {
  id = join("-",list(var.namespace,var.stage,var.name))
  tags = {
      Name      = local.id
      Namespace = var.namespace
      Stage     = var.stage
  }
}

resource "aws_subnet" "main" {
  for_each          = var.subnet_config_map
  vpc_id            = var.vpc.vpc_id
  availability_zone = each.key
  cidr_block        = var.subnet_config_map[each.key].cidr_block

  # use the default label.tags, but override name tag to prefix the AZ
  tags = merge(
    local.tags,
    map(
      "Name", "${local.id}-private-${each.key}"
    ),
    var.additional_subnet_tags,
  )
}

resource "aws_route_table" "main" {
  for_each          = var.subnet_config_map
  vpc_id            = var.vpc.vpc_id

  # Route to internet
  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = var.public_subnets_map[each.key].nat.id
  }

  # use the default label.tags, but override name tag to prefix the AZ
  tags = merge(
    local.tags,
    map(
      "Name", "${local.id}-private-${each.key}"
    )
  )
}

# associate private routing table with private subnets
resource "aws_route_table_association" "main" {
  for_each       = var.subnet_config_map
  route_table_id = aws_route_table.main[each.key].id
  subnet_id      = aws_subnet.main[each.key].id
}
