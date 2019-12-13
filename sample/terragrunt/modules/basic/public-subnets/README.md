## Public Subnets

Creates public (Tier1) subnets (1 for all 3 AZs) which use default route through IGW and with NAT Gateways for public internet access

EIPs are expected to be passed in to allow dependency inversion between modules - ref https://www.terraform.io/docs/modules/composition.html

See ../composed/network
