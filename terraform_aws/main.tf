terraform {
  // terraform 버전이 1.0.0버전 이상 2.0.0버전 미만
  required_version = ">= 1.0.0, < 2.0.0"
  
  required_providers {
  aws = {
    source = "hashicorp/aws"
    // aws provider 버전이 4.0버전 이상인 경우 실행
    version = "~> 5.0"
    }
  }
}
provider "aws" {
region = "ap-northeast-2"
}

# VPC
resource "aws_vpc" "Seminar_VPC" {
  cidr_block = "10.10.10.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "Seminar_VPC"
  }
}

# Subnet
resource "aws_subnet" "Seminar_2a_public"{
  vpc_id = aws_vpc.Seminar_VPC.id
  cidr_block = "10.10.10.0/26"
  tags = {
    Name = "Seminar_Subnet_public"
  }
}
resource "aws_subnet" "Seminar_2a_private"{
  vpc_id = aws_vpc.Seminar_VPC.id
  cidr_block = "10.10.10.64/26"
  tags = {
    Name = "Seminar_Subnet_pricate_1"
  }
}
resource "aws_subnet" "Seminar_2b"{
  vpc_id = aws_vpc.Seminar_VPC.id
  cidr_block = "10.10.10.128/26"
  tags = {
    Name = "Seminar_Subnet_private_2"
  }
}
resource "aws_subnet" "Seminar_2c"{
  vpc_id = aws_vpc.Seminar_VPC.id
  cidr_block = "10.10.10.192/26"
  tags = {
    Name = "Seminar_Subnet_private_3"
  }
}

# IGW 
resource "aws_internet_gateway" "Seminar_IGW" {
  vpc_id = aws_vpc.Seminar_VPC.id
  tags = {
    Name = "Seminar_IGW"
  }
}

# Elastic IP


# NAT Gateway
resource "aws_nat_gateway" "Seminar_NAT" {
  
  subnet_id = aws_subnet.Seminar_2a_public
  tags = {
    Name = "Seminar_NAT"
  }

  depends_on = [ aws_internet_gateway.Seminar_IGW ]
}

# Routing Table(public subnet)
# Routing Table(private subnet)


# Network ACL

# SG(Security Group)


# EC2
/*
resource "aws_instance" "name" {
  ami = "ami-0c593c3690c32e925"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform-test"
  }
}
*/