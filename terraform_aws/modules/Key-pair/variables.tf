variable "aws_bastion_key" {
  description = "AWS Bastion 키"
  type = string
  default = "seminar_key"
}

variable "aws_connector_key" {
  description = "CVO Connector key name"
  type = string
  default = "connector_key"
}

variable "aws_mediator_key" {
  description = "CVO Mediator key name"
  type = string
  default = "mediator_key"
}