# S3 Bucket - Simple

TF Module to create a bucket while forcing convention for name and tags, plain and simple

IAM policies is not handled by this module to maximise re-use.

## Variables

|           Name            |       Default        |                                  Description                                   |Required|
|:--------------------------|:---------------------|:-------------------------------------------------------------------------------|:-------|
|`access                   `|`private             `|Canned ACL                                                                      |No      |
|`force_destroy            `|`false               `|Destroy even if it is a non-Terraform-managed bucket                            |No      |
|`name                     `|`None                `|Name for bucket                                                                 |Yes     |
|`namespace                `|`cag                 `|`cag`. This will be used to scope the bucket name                               |No      |
|`stage                    `|`stage               `|Stage / Environment (e.g. `stage`, `prod`)                                      |No      |

