variable "aws_region" {
  description = "The AWS Region to provision the network in"
  type        = string
  default     = "ap-southeast-1"
}

variable "output_dir" {
  type = string
}

variable "name" {
  description = "Name"
}

variable "namespace" {
  description = "`cag`. This will be used to scope the name"
  default     = "cag"
}

variable "stage" {
  description = "Stage / Environment (e.g. `stage`, `prod`)"
  default     = "stage"
}

variable "state_store" {
  description = "URI to kops state store (i.e s3://my-state-store)"
}

variable "cluster_name" {
  description = "DNS valid cluster name as required by kops"
}

variable "kubernetes_version" {
  type    = string
  default = "1.15.5"
}

variable "templates_version" {
  description = "Allows fine tuning the templates during cluster upgrades"
  type        = string
  default     = "v0.1.0"
}

variable "ami" {
  default = "kope.io/k8s-1.15-debian-stretch-amd64-hvm-ebs-2019-09-26"
}

variable "nodes_min_size" {
  type    = number
  default = 2
}

variable "nodes_max_size" {
  type    = number
  default = 12
}

variable "vpc" {
  type = object({
    vpc_id     = string
    cidr_block = string
  })
}

variable "utility_subnets" {
  description = "AZ to subnet list map"
  type = map(object({
    subnet = object({
      id = string
    })
  }))
  default = {}
}

variable "node_subnets" {
  description = "AZ to subnet list map"
  type = map(object({
    subnet = object({
      id = string
    })
  }))
  default = {}
}

variable "allowed_cidr_blocks" {
  type = list(string)
}

variable "extdns_zones" {
  description = "list of Route53 ZoneIds the cluster masters (externalDNS) should be allowed to change"
  type        = list(object({
    id = string
  }))
  default     = []
}

variable "master_roles" {
  description = "list of roles the cluster masters should be allowed to assume"
  type        = list(string)
  default     = []
}
