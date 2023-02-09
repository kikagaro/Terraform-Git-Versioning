locals {
  ssm_context = "${var.org-name}/${var.stage}/${var.app-name}"

  tags = {
    "Organization" : var.org-name
    "Stage" : var.stage
    "Application" : var.app-name
    "Terraform" : "true"
    "Version" : data.local_file.git_branch_tag_version.content
  }
}

resource "null_resource" "git_branch_tag" {
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    on_failure = fail
    when = create
    interpreter = ["/bin/bash", "-c"]
    command = <<EOF
      echo -e "Grabbing Git branch/tag for versioning"
      (git describe --tags --exact-match || git describe --tags || git symbolic-ref -q --short HEAD) 2> /dev/null | tr -d '\n' > ${path.module}/version.txt
    EOF
  }
}

data "local_file" "git_branch_tag_version" {
  depends_on = [null_resource.git_branch_tag]
  filename = "${path.module}/version.txt"
}

resource "aws_ssm_parameter" "deployed_git_version" {
  count = var.ssm-output-version != false ? 1 : 0
  name = "/${local.ssm_context}/git/deployed/version"
  type = "String"
  value = data.local_file.git_branch_tag_version.content

  tags = local.tags
}

# Output for reference in modules that import this.
output "git_tag_ref" {
  value = data.local_file.git_branch_tag_version.content
}

