# Terraform provider kops

Manage kops clusterSpec / instanceGroupSpec manifests through Terraform.

The goal is to just render TF resource Ids into kops templated manifests and push them into the kops state store

All cluster ops are still done through kops binary outside of terraform workflow

## ToDo:

- [ ] Better diff detection
