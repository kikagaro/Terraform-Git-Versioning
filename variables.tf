variable "env" {
  description = "Name of the environment."
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

variable "ssm-output-version" {
  description = "True/False for creatting SSM output"
  type = bool
  default = false
}