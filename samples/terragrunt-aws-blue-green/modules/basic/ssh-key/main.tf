variable "output_dir" {
  type = string
}

variable "aws_key_name" {
  type = string
}

variable "key_file" {
  default = "id_rsa"
}

# TF warnings all warn against storing it unencrypted into TF state file
# but the TF state file is encrypted in S3 ...
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "filesystem_file_writer" "ssh_private_key" {
  path                 = "${var.output_dir}/${var.key_file}"
  contents             = tls_private_key.ssh_key.private_key_pem
  mode                 = "0600"
}

resource "filesystem_file_writer" "ssh_public_key" {
  path                 = "${var.output_dir}/${var.key_file}.pub"
  contents             = tls_private_key.ssh_key.public_key_openssh
  mode                 = "0644"
}


resource "aws_key_pair" "ssh_key" {
  key_name   = var.aws_key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

output "aws_key_name" {
  value = var.aws_key_name
}
