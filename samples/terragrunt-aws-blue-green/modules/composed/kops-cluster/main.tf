locals {
  id = join("-",list(var.namespace,var.stage,var.name))
  tags = {
    Name      = local.id
    Namespace = var.namespace
    Stage     = var.stage
  }
}

module "ssh_key" {
  source       = "../../basic/ssh-key"
  aws_key_name = local.id
  output_dir   = "${var.output_dir}/.ssh"
  key_file     = "id_rsa" # the default key file name
}

locals {
  masters = {
    a = "n_a"
    b = "n_b"
    c = "n_a"
  }
}

resource "kops_cluster" "main" {
  content = jsonencode(yamldecode(templatefile(
    "${path.module}/templates/${var.templates_version}/cluster-spec.yaml",
    {
      state_store         = var.state_store
      ssh_key_name        = module.ssh_key.aws_key_name
      cluster_name        = var.cluster_name
      kubernetes_version  = var.kubernetes_version
      vpc                 = var.vpc
      utility_subnets     = var.utility_subnets
      node_subnets        = var.node_subnets
      extdns_zones        = formatlist("arn:aws:route53:::hostedzone/%s", var.extdns_zones.*.id)
      master_roles        = var.master_roles
      allowed_cidr_blocks = var.allowed_cidr_blocks # additional cidr_blocks asside from vpc_cidr_block
    }
  )))
}

resource "kops_instance_group" "main_masters" {
  for_each = local.masters
  cluster_name = kops_cluster.main.id
  content = jsonencode(yamldecode(templatefile(
    "${path.module}/templates/${var.templates_version}/master-spec.yaml",
    {
      cluster_name  = var.cluster_name
      ami           = var.ami
      master_name   = "master-${each.key}"
      master_subnet = "${each.value}"
    }
  )))
}

resource "kops_instance_group" "main_nodes_spot" {
  cluster_name = kops_cluster.main.id
  content = jsonencode(yamldecode(templatefile(
    "${path.module}/templates/${var.templates_version}/nodes-spec.yaml",
    {
      cluster_name    = var.cluster_name
      node_group_name = "nodes-spot"
      ami             = var.ami
      min_size        = var.nodes_min_size
      max_size        = var.nodes_max_size
    }
  )))
}
