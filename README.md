# Terraform-Git-Versioning
The repo was created with the purpose of reusing git tags for versioning and stream lining the process. 

This is meant to be used as a module within any terraform project.

## What does this do?
This module makes use of a "null_resource" within terraform to run a command within your local git directory.
The command interacts makes use of your git tags and prepares it for use within Terraform.

Command being ran:
```commandline
(git describe --tags --exact-match || git describe --tags || git symbolic-ref -q --short HEAD) 2> /dev/null | tr -d '\n' > ${path.module}/version.txt
```
This command is primary 3 parts:
* git describe --tags --exact-match
* git describe --tags
* git symbolic-ref -q --short HEAD

In order this will attempt each command and if it fails move to the next. Once one of the 3 commands is successful
it will output the value into a `version.txt` file within the module folder. Pending which command completed this
value will look like 1 of 3 options pending the tag/commit/branch you have checked out for your deployment:

An exact match of the current Git tag for your current branch:
```commandline
kikagaro@Kikagaro:~$ git describe --tags --exact-match
v2.28.2
```
An expanded version of the tag:
```commandline
kikagaro@Kikagaro:~$ git describe --tags
v2.27.0-34-g1146219
```
*Note: In the above example, you can read this as 3 parts:*
1. v2.27.0 : The current head branch for the commit you are on.
2. 34 : The number of additional commits since the tag.
3. g1146219 : The first 7 characters of the commit SHA prefixed with "g".

The name of the branch:
```commandline
kikagaro@Kikagaro:~$ git symbolic-ref -q --short HEAD
master
```
Once the value is stored in the `version.txt` file, it is then loaded into terraform using a data resource.
The value of this resource is then referenced as an output for use within your own terraform projects.

## Basic Module usage in Terraform:

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

Sample output usage for use in your tags or other resources:
```
locals {
  tags = {
    "Orginization": Example_Org
    "Stage" : Example_Stage
    "Version" : module.git-versioning.git_tag_ref
  }
}
```

### Note:
*This will only be able to grab the git tag/branch of the repo of your current git directory. This will
not work for submodules.*