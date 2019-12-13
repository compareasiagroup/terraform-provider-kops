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

variable "vpc" {
    description = "The VPC to create the subnets in"
    type = object({
        vpc_id      = string
        # cidr_block  = string
        # igw_id      = string
        # main_rtb_id = string
    })
}

variable "subnet_config_map" {
  type = map(object({
      cidr_block = string,
      eip        = object({
        # Declare an object using only the subset of attributes the module
        # needs. Terraform will allow any object that has at least these
        # attributes.
        id           = string
      })
  }))
  description = "A map of az to subnet objects (cidr_block / eip)"
}

variable "additional_subnet_tags" {
  description = "Additional tags for subnets"
  type = map(string)
}
