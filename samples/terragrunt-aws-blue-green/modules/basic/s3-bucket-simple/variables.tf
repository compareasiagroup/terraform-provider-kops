variable "name" {
  description = "Name for bucket"
}

variable "namespace" {
  description = "`cag`. This will be used to scope the bucket name"
  default     = "cag"
}

variable "stage" {
  description = "Stage / Environment (e.g. `stage`, `prod`)"
  default     = "stage"
}

variable "force_destroy" {
  description = "Destroy even if it is a non-Terraform-managed bucket"
  default     = false
}

variable "access" {
  description = "Canned ACL"
  default     = "private"
}

variable "versioning" {
  description = "Enable versioning (can not be disabled once enabled)"
  default = false
}
