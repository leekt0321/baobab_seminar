variable "aws_instance_type" {
  description = "AWS instance type"
  type = string
  default = "t3.micro"
}

variable "Seminar_2a_public" {
  type = string
}

variable "bastion_key" {
  type = string
}

variable "security_group" {
  type = string
}