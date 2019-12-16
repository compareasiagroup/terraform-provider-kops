output "subnets_map" {
  description = "A map of subnets, nat gateways created per az"
  value       = {for az, subnet in aws_subnet.main:
    az => {
        subnet = subnet
        nat    = aws_nat_gateway.main[az]
    }
  }
}
