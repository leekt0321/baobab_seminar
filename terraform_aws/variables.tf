# variable.tf
variable "aws_region"{
    description = "AWS 리전"
    type = string
    default = "ap-northeast-2"
}
variable "aws_az_a"{
    description = "AWS AZ 2a"
    type = string
    default = "ap-northeast-2a"
}
variable "aws_az_c"{
    description = "AWS AZ 2c"
    type = string
    default = "ap-northeast-2c"
}
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

variable "aws_Seminar_2a_private_cidr"{
    description = "AWS_2a_private_subnet"
    type = string
    default = "10.10.10.64/26"
}

variable "aws_Seminar_2c_private_cidr"{
    description = "AWS_2c_private_subnet"
    type = string
    default = "10.10.10.128/26"
}

variable "aws_Seminar_2a_public_cidr"{
    description = "AWS_2a_public_subnet"
    type = string
    default = "10.10.10.0/26"
}

variable "aws_VPC"{
    description = "AWS_VPC"
    type = string
    default = "10.10.10.0/24"
}

variable "aws_instance_type" {
  description = "AWS instance type"
  type = string
  default = "t2.micro"
}

variable "refresh_token" {
  description = "blueXP API refresh_token"
  type = string
  sensitive = true
}

variable "svm_password" { // 초기 비밀번호
    description = "Password for the CVO SVM admin"
    type = string
    sensitive = true
  
}