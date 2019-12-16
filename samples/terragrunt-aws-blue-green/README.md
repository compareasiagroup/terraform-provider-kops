# Terragrunt AWS: Blue / Green Kubernetes cluster infrastructure

This is a sample AWS infrastructure with following features:

- Centralized DNS management through Route53 in a single AWS Account, allowing an `AWS Account per Environment` infrastructure with delegation of shared DNS configuration 
- Automated AWS IAM roles and permissions for cross-account Kubernetes External DNS / Cert Manager configuration
- 3 Tier Network design for VPCs across `X` Availability Zones
- Fully private Kubernetes clusters only accessible from within the VPC (this sample does **NOT** include code to provision VPN for kube API access)
- Blue/Green Kubernetes Cluster configuration in a single VPC for stateless cluster upgrades and roll-overs

To use the sample code: [Terraform AWS provider configuration](https://www.terraform.io/docs/providers/aws/), [Terraform provider kops](https://github.com/compareasiagroup/terraform-provider-kops#usage), [Terraform provider filesystem](#terraform-provider-filesystem) and [Terragrunt](https://github.com/gruntwork-io/terragrunt#install-terragrunt) are required.

## Overview

The sample follows the folder layout as suggested by the book [Terraform up and running](http://shop.oreilly.com/product/0636920225010.do) - which is highly recommended to provide more context.

The `live` folder contains an actual instantiation of the Cloud Infrastructure defined in the `modules` (describe below) folder:

```
$ tree -L 3 live/
live/
├── account-1
│   ├── account_vars.yaml   # Variables shared within single AWS account
│   ├── account-base
│   │   └── terragrunt.hcl  # Route53 Zone + IAM Rights
│   │
│   └── terragrunt.hcl      # Account level Terragrunt configuration
├── account-2
│   ├── account_vars.yaml   # Variables shared within single AWS account
│   ├── foo
│   │   └── terragrunt.hcl  # VPC + 3 Tier Subnet configuration
│   ├── foo-cluster-blue
│   │   └── terragrunt.hcl  # Stateless "Blue" Kube cluster within foo network
│   ├── foo-cluster-green
│   │   └── terragrunt.hcl  # Stateless "Green" Kube cluster within foo network
│   ├── foo-data
│   │   └── terragrunt.hcl  # Data Tier within foo network
│   │
│   └── terragrunt.hcl      # Account level Terragrunt configuration
│
├── root_vars.yaml          # Variables shared within project 
├── init.sh
└── terragrunt.hcl          # Placeholder config allowing Terragrunt to locate root_vars
```

[Terragrunt](https://github.com/gruntwork-io/terragrunt) is used as the powertool to easily implement the above folder layout.

Terragrunt allows us to layer our cloud infrastructure cleanly, share variables across layers, define dependencies between layers and automate separate terraform state management per layer making sure we keep our configuration DRY and maintainable. More information about Terragrunt (installation & configuration) is available on Terragrunt repository and in the book mentioned above.

This sample is fully self-contained, no external Terraform modules are used. By storing modules within the same repository, we do not have the ability to version pin the modules. Versioning the modules would be crucial if the sample code is adopted to manage multiple environments such as Dev, Staging & Production which is not included in this sample code.

As Terragrunt requires you to instantiate modules and keeps a state file per module, we opted to use 2 types of modules:

```
$ tree -L 2 modules/
modules/
├── basic                   # Single purpose modules for composition, not meant to be instantiated by terragrunt
│   ├── README.md
│   ├── private-subnets
│   ├── public-subnets
│   ├── s3-bucket-simple
│   ├── ssh-key
│   └── vpc
└── composed                # Composition of basic modules and Terraform resources directly, 
    │                       # includes TF provider blocks (which are instantiated once and inherited within)
    │                       # these represent all resources we are comfortable storing within a single TF State
    ├── README.md
    ├── account-base          # Meant for basic AWS Account bootstrap
    ├── network               # Defines an isolated network with 3 tiers of subnets: Public, Application & Data
    └── kops-cluster          # Depends on network configuration, uses terraform-provider-kops for k8s cluster definition
```

## Additional requirements

### terraform-provider-filesystem

- Download the compiled binary for Terraform 0.12 from [GitHub releases](https://github.com/sethvargo/terraform-provider-filesystem/releases).

- Unzip/untar the archive.

- Move it into `$HOME/.terraform.d/plugins`:

```sh
# OSX download one-liner
$ curl -L https://github.com/sethvargo/terraform-provider-filesystem/releases/download/v0.1.1/darwin_amd64.tgz | tar -xzf -

$ mkdir -p $HOME/.terraform.d/plugins
$ mv terraform-provider-filesystem $HOME/.terraform.d/plugins/terraform-provider-filesystem
```

- Create your Terraform configurations as normal, and run `terraform init`:

```sh
$ terraform init
```

Note: this custom provider fails when files exist in the TF state but not on disk, a script to prevent this failure is provided as [live/init.sh](live/init.sh)
