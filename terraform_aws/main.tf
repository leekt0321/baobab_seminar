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