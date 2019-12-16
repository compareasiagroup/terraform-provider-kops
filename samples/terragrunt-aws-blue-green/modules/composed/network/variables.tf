variable "name" {
  description = "Name"
}

variable "cidr_block" {
  description = "CIDR block used for Environment Network"
}

variable "kube_cluster_zones" {
  description = "DNS zones used for kube clusters"
  type        = list(string)
  default     = []
}

variable "namespace" {
  description = "`cag`. This will be used to scope the name"
  default     = "cag"
}

variable "stage" {
  description = "Stage / Environment (e.g. `stage`, `prod`)"
  default     = "stage"
}

variable "aws_region" {
  description = "The AWS Region to provision the network in"
  type        = string
  default     = "ap-southeast-1"
}

# list of availability zones for subnets
variable "az" {
  description = "list of Availability Zones to create subnets in and number of cidr sub range to use"
  type        = list(object({
      zone   = string
      number = number
    })
  )
  default     = [
    {
      zone   = "ap-southeast-1a"
      number = 0
    },
    {
      zone   = "ap-southeast-1b"
      number = 1
    },
    {
      zone   = "ap-southeast-1c"
      number = 2
    },
  ]
}

variable "public_additional_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "kube_cluster_blue_additional_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "kube_cluster_green_additional_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "data_additional_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "output_dir" {
  type = string
}
