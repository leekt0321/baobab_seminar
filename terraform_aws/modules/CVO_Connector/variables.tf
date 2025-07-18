variable "aws_region"{
    description = "AWS 리전"
    type = string
    default = "us-east-2" # ap-northeast-2
}

variable "aws_connector_key" {
  description = "CVO Connector key name"
  type = string
  default = "connector_key"
}

variable "cvo_connector_EC2_profile_name" {
  type = string
}

variable "Seminar_2a_private_id" {
  type = string
}

variable "security_group_id" {
  type = string
}