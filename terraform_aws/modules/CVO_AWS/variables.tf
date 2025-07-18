variable "aws_region"{
    description = "AWS 리전"
    type = string
    default = "us-east-2" # ap-northeast-2
}

variable "aws_mediator_key" {
  description = "CVO Mediator key name"
  type = string
  default = "mediator_key"
}

variable "svm_password" { // 초기 비밀번호
    description = "Password for the CVO SVM admin"
    type = string
    sensitive = true
}

variable "Seminar_2c_private_id" {
  type = string
}

variable "Seminar_VPC_id" {
  type = string
}

variable "CVO_connector_aws_client_id" {
  type = string
}

variable "Seminar_2a_private_id" {
  type = string
}

variable "cvo_connector_EC2_profile_name" {
  type = string
}

variable "private_route_table_id" {
  type = string
}

variable "public_route_table_id" {
  type = string
}