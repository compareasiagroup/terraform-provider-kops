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
  description = "The VPC to create the private subnets in"
  type = object({
      # cidr_block  = string
      # igw_id      = string
      # main_rtb_id = string
      vpc_id                 = string
  })
}

variable "subnet_config_map" {
  type = map(object({
      cidr_block = string
  }))
  description = "A map of az to subnet config (cidr_block)"
}

variable "public_subnets_map" {
  description = "The public subnets and nat gateways per az map"
  type = map(
    object({
      subnet = object({
        id = string
      })
      nat = object({
        id = string
      })
    })
  )
}

variable "additional_subnet_tags" {
  description = "Additional tags for subnets"
  type = map(string)
}
