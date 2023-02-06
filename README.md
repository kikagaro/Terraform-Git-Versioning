# Terraform-Git-Versioning
Terraform resources for using Git tagging to handle versioning.

## Basic Module usage:

HTTPS:
```
module "git-versioning" {
  source = "git::https://github.com/kikagaro/Terraform-Git-Versioning.git?ref=1.0.0"

  org-name = organization
  stage    = preprod
  app-name = example-application
  ssm-output-version = true # Defaults false
}
```
SSH:
```
module "git-versioning" {
  source = "git::ssh://git@github.com/kikagaro/Terraform-Git-Versioning.git?ref=1.0.0"

  org-name = organization
  stage    = preprod
  app-name = example-application
  ssm-output-version = true # Defaults false
}
```

Sample output usage for use in tags:
```
locals {
  tags = {
    "Orginization": Example_Org
    "Stage" : Example_Stage
    "Version" : module.git-versioning.git_tag_ref
  }
}
```

# Note:
* This will only be able to grab the git tag/branch of the repo of your current git directory. This will
not work for submodules.