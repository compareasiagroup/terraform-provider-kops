remote_state {
  backend = "s3"
  config = {
    bucket         = "sample-demo-account-1-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "sample-demo-tfstate"
  }
}

inputs = {
  aws_region = "ap-southeast-1"
  # because local_file provider stores the file path in state, we have to define an absolute path
  output_dir = get_terragrunt_dir()
}
