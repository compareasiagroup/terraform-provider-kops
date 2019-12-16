locals {
  id = join("-",list(var.namespace,var.stage,var.name))
  tags = {
      Name = local.id
      Namespace = var.namespace
      Stage = var.stage
  }
}


resource "aws_s3_bucket" "default" {
  bucket        = local.id
  acl           = var.access
  tags          = local.tags
  force_destroy = var.force_destroy
  versioning {
    enabled = var.versioning
  }
}
