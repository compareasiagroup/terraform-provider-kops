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

variable "kube_cluster_zones" {
  description = "The DNS Zones for kube clusters in the VPC"
  type        = list(string)
}

variable "cidr_block" {
  description = "cidr for VPC (eg 10.90.0.0/20)"
}
