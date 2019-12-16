# Kops Cluster

This module uses the powerful TF 0.12 templating to manage the Kops resource manifests.

As the `terraform-provider-kops` plugin tries to avoid tight coupling to kops internal schemas by not implementing traditional TF provider "flatten" and "expand" functionality, 
but instead relies on TF 0.12's ability to manage json objects directly, the usage of the provider is slightly more complex. This module aims to simplify this usage by exposing
cluster specific configurations through variables.

Disclaimer: This module generates a public/private SSH Key pair for cluster nodes, storing both in the Terraform state. This is against recommendations from Hashicorp to store both in TF Sate,
although we may improve security by ensuring the Terraform state is stored encrypted in an S3 bucket. If this is a concern, do note that Kops by default stores cluster PKI and other credentials 
within the kops state bucket by default.

## Variables

|           Name            |       Default        |                                  Description                                   |Required|
|:--------------------------|:---------------------|:-------------------------------------------------------------------------------|:-------|
|`state_store              `|`None                `|URI to kops state store (i.e s3://my-state-store) - required by Kops provider   |Yes     |
|`cluster_name             `|`None                `|DNS valid cluster name as required by kops                                      |Yes     |
|`vpc                      `|`None                `|Complex type, `vpc_id` and `cidr_block` are minimum required attributes         |Yes     |
|`utility_subnets          `|`{}                  `|Map of AZ to Public subnet complex type, `subnet.id` required attribute per subnet|Yes     |
|`node_subnets             `|`{}                  `|Map of AZ to Private subnet complex type, `subnet.id` required attribute per subnet, shared by Masters and Workers|Yes     |
|`kubernetes_version       `|`1.15.5              `|Kubernetes version for kops cluster                                             |No      |
|`ami                      `|`kope.io/k8s-1.15-debian-stretch-amd64-hvm-ebs-2019-09-26`|Host OS ami                                 |No      |
|`allowed_cidr_blocks      `|`None                `|Additional Cidr blocks to allow kube API / SSH traffic from (full VPC Cidr is allowed by default)|Yes      |
|`nodes_min_size           `|`2                   `|Workers Autoscaling Group min size                                              |No      |
|`nodes_max_size           `|`12                  `|Workers Autoscaling Group max size                                              |No      |
|`extdns_zones             `|`{}                  `|list of Complex type for route53 zones (`id` is minimum required attribute)     |No      |
|`master_roles             `|`[]                  `|Additional roles masters may assume, i.e. may be required for externalDNS to manage certain Route53 zones in another AWS Account|No      |
|`templates_version        `|`v0.1.0              `|Allows different kops template versions without module version pinning          |No      |
|`namespace                `|`cag                 `|`cag`. This will be used to scope the name                                      |No      |
|`stage                    `|`stage               `|Stage / Environment (e.g. `stage`, `prod`)                                      |No      |
|`name                     `|`None                `|Name for resources (currently only used for SSH Keys)                           |Yes     |
|`aws_region               `|`ap-southeast-1      `|The AWS Region required for the TF Provider                                     |No      |
|`output_dir               `|`false               `|May be used to locally store artifacts created by this module (SSH Keys)        |No      |

## Notes

The trade-off of treating the kops manifests as single json objects, means we lose some features of strongly typed TF resources. The TF templated yaml is unaware of 
the document structure (templates are rendered to text before being deserialized). This may lead to obscure and hard to debug deserialization errors). We accept 
this trade off as Manifest templates are defined once and re-used across multiple clusters many times.
