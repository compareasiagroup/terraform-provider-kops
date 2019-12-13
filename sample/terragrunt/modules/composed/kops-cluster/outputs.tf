output "state_store" {
  value = var.state_store
}

output "apply_command" {
  value = "KOPS_STATE_STORE=${var.state_store} kops update cluster ${var.cluster_name}"
}

# # Placeholder code for quick debug using `terragrunt refresh`
# output "masters_spec" {
#   value = yamldecode(templatefile(
#     "${path.module}/templates/${var.templates_version}/cluster-spec.yaml",
#     {
#       state_store         = var.state_store
#       ssh_key_name        = module.ssh_key.aws_key_name
#       cluster_name        = var.cluster_name
#       kubernetes_version  = var.kubernetes_version
#       vpc                 = var.vpc
#       utility_subnets     = var.utility_subnets
#       node_subnets        = var.node_subnets
#       data_subnets        = var.data_subnets
#       extdns_zones        = formatlist("arn:aws:route53:::hostedzone/%s", var.extdns_zones.*.id)
#       allowed_cidr_blocks = []                # additional cidr_blocks asside from vpc_cidr_block
#     }
#   ))
# }
