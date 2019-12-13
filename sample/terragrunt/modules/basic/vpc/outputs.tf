output "vpc_id" {
  value = aws_vpc.main.id
}

output "cidr_block" {
  value = var.cidr_block
}

output "igw_id" {
  value = aws_internet_gateway.main.id
}

output "internal_zones" {
  value = aws_route53_zone.internal
}

output "main_rtb_id" {
  description = "Main routing table Id"
  value       = aws_route_table.main.id
}
