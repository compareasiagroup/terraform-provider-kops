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

variable "public_zones" {
  description = "Public Route53 Zones"
  type        = map(object({
    parent           = string      # set up NS record in this zone
    trusted_accounts = map(string) # Map of account name to account id for public zone CRUD rights
  }))
  default     = {}
}

variable "aws_region" {
  type = string
}
