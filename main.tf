provider "kops" {
    state_store = "s3://k8-test-kstate"
}

# kope.io/k8s-1.15-debian-stretch-amd64-hvm-ebs-2019-09-26
resource "kops_cluster" "donger" {
    content = jsonencode(yamldecode(templatefile(
        "templates/cluster-spec.yaml",
        {
            cluster_name = "k8.donger.example.xom"
            ssh_key_name = "donger-kops"
            vpc = {
              "cidr_block" = "10.40.0.0/20"
              "vpc_id" = "vpc-abcd"
            }
            allowed_cidr_blocks = []
            utility_subnets = {
                "ap-southeast-1a" = {
                    "subnet" = {
                        "id" = "subnet-abcd"
                    }
                }
                "ap-southeast-1b" = {
                    "subnet" = {
                        "id" = "subnet-efgh"
                    }
                }
                "ap-southeast-1c" = {
                    "subnet" = {
                        "id" = "subnet-jklm"
                    }
                }
            }
            node_subnets = {
              "ap-southeast-1a" = {
                "subnet" = {
                  "id" = "subnet-nopq"
                }
              }
              "ap-southeast-1b" = {
                "subnet" = {
                  "id" = "subnet-rstu"
                }
              }
              "ap-southeast-1c" = {
                "subnet" = {
                  "id" = "subnet-vwxy"
                }
              }
            }
            data_subnets = {
              "ap-southeast-1a" = {
                "subnet" = {
                  "id" = "subnet-z123"
                }
              }
              "ap-southeast-1b" = {
                "subnet" = {
                  "id" = "subnet-4567"
                }
              }
              "ap-southeast-1c" = {
                "subnet" = {
                  "id" = "subnet-890a"
                }
              }
            }
        }
    )))
}

locals {
  masters = {
    a = "n_a"
    b = "n_b"
    c = "n_a"
  }
}

resource "kops_instance_group" "donger-masters" {
  for_each = local.masters
  cluster_name = kops_cluster.donger.id
  content = jsonencode(yamldecode(templatefile(
      "templates/master-spec.yaml",
      {
          cluster_name = "k8.donger.example.com"
          master_name = "master-${each.key}"
          master_subnet = "${each.value}"
      }
  )))
}

resource "kops_instance_group" "donger-nodes" {
    cluster_name = kops_cluster.donger.id
    content = jsonencode(yamldecode(templatefile(
        "templates/nodes-spec.yaml",
        {
            cluster_name = "k8.donger.example.com"
            min_size = 2
            max_size = 12
        }
    )))
}
