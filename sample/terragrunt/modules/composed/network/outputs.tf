output "vpc" {
  value = module.vpc
}

output "public_subnets" {
  value = module.public_subnets
}

output "kube_cluster_blue_subnets" {
  value = module.kube_cluster_blue_subnets
}

output "kube_cluster_green_subnets" {
  value = module.kube_cluster_green_subnets
}

output "data_subnets" {
  value = module.data_subnets
}

output "kube_cluster_zones" {
  value = var.kube_cluster_zones
}

output "kops_state_bucket" {
  value = module.kops_state_bucket.bucket
}

output "internal_zones" {
  value = module.vpc.internal_zones
}