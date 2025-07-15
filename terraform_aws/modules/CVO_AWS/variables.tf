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