variable "org-name" {
  description = "Name of the Organization."
  type = string
}

variable "stage" {
  description = "Name of the stage in the environment."
  type = string
}

variable "app-name" {
  description = "Name of the application"
  type = string
}

variable "aws-ssm-parameter" {
  description = "True/False for creating SSM output"
  type = bool
  default = false
}