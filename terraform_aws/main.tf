terraform {
  // terraform 버전이 1.0.0버전 이상 2.0.0버전 미만
  required_version = ">= 1.0.0, < 2.0.0"
  
  required_providers {
  aws = {
    source = "hashicorp/aws"
    // aws provider 버전이 4.0버전 이상인 경우 실행
    version = "~> 4.0"
    }
  }
}
provider "aws" {
region = "ap-northeast-2"
}

resource "aws_instance" "name" {
  ami = "ami-0c593c3690c32e925"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform-test"
  }
}