# Network configuration

Standard configuration for 3 Tier Application Network, including; VPC, Subnets,Routing Tables and NAT Gateways.

## Resolving Private Hosted Zones in other AWS accounts

This manual step is still required ...

```
// newly created hosted zone
hosted_zone_id=Z081........ # CHANGE THIS

// management vpc 
vpc_spec=VPCRegion=ap-southeast-1,VPCId=vpc-07....... # THIS IS account-1 VPN
vpc_spec=VPCRegion=ap-southeast-1,VPCId=vpc-09....... # THIS IS account-2 VPN

AWS_PROFILE=account-2
awssso --region us-east-1 login -p ${AWS_PROFILE} -a ${AWS_PROFILE}
aws route53 create-vpc-association-authorization --hosted-zone-id $hosted_zone_id --vpc $vpc_spec

AWS_PROFILE=account-1
awssso --region us-east-1 login -p ${AWS_PROFILE} -a ${AWS_PROFILE}
aws route53 associate-vpc-with-hosted-zone --hosted-zone-id $hosted_zone_id --vpc $vpc_spec
```
