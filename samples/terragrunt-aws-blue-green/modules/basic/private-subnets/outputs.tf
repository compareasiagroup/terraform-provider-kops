output "subnets_map" {
  description = "A map of subnets, routing tables created per az"
  value       = {for az, subnet in aws_subnet.main:
    az => {
        subnet = subnet
        rtb    = aws_route_table.main[az]
    }
  }
}
