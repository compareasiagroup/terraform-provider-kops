# Terraform provider kops

Manage kops clusterSpec / instanceGroupSpec manifests through Terraform.

The goal is to just render TF resource Ids into kops templated manifests and push them into the kops state store

All cluster ops are still done through kops binary outside of terraform workflow

## Usage

- Download the compiled binary for Terraform 0.12 and Kops 1.15 from [GitHub releases](https://github.com/compareasiagroup/terraform-provider-kops/releases/tag/0.1.0)

- Unzip/untar the archive

- Move it into `$HOME/.terraform.d/plugins`:

```sh
$ curl -L https://github.com/compareasiagroup/terraform-provider-kops/releases/download/0.1.0/terraform-provider-kops_0.1.0_darwin_amd64.tgz | tar -xzf -

$ mkdir -p $HOME/.terraform.d/plugins
$ mv terraform-provider-kops $HOME/.terraform.d/plugins/terraform-provider-kops
```

- Create your Terraform configurations as normal, and run `terraform init`:

```sh
terraform init
```

See [samples](samples) for examples of using this provider for creating and managing Kops clusters within your cloud provider of choice.

## ToDo:

- [ ] Better diff detection
