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
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "Seminar_Subnet_public"
  }
}
resource "aws_subnet" "Seminar_2a_private"{
  vpc_id = aws_vpc.Seminar_VPC.id
  cidr_block = "10.10.10.64/26"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "Seminar_Subnet_pricate_1"
  }
}
resource "aws_subnet" "Seminar_2b_private"{
  vpc_id = aws_vpc.Seminar_VPC.id
  cidr_block = "10.10.10.128/26"
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "Seminar_Subnet_private_2"
  }
}
resource "aws_subnet" "Seminar_2c_private"{
  vpc_id = aws_vpc.Seminar_VPC.id
  cidr_block = "10.10.10.192/26"
  availability_zone = "ap-northeast-2c"
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
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}


# NAT Gateway(각 AZ마다 구성하는 것이 좋지만 편의상 2a에만 생성)
resource "aws_nat_gateway" "Seminar_NAT" {
  
  subnet_id = aws_subnet.Seminar_2a_public.id
  allocation_id = aws_eip.nat_eip.id
  tags = {
    Name = "Seminar_NAT"
  }

  depends_on = [ aws_internet_gateway.Seminar_IGW ]
}

# Routing Table(public subnet)
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.Seminar_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Seminar_IGW.id
  }
  tags = {
    Name = "public_route_table_Seminar"
  }
}

# Routing Table Association(public subnet)
resource "aws_route_table_association" "public_association" {
  subnet_id = aws_subnet.Seminar_2a_public.id
  route_table_id = aws_route_table.public_route_table.id
  
}


# Routing Table(private subnet)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.Seminar_VPC.id
  route{
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Seminar_NAT.id
  }
  tags = {
    Name = "private_route_table_Seminar"
  }
  
}

# Routing Table Association(private subnet)
resource "aws_route_table_association" "private_association_2a" {
 subnet_id = aws_subnet.Seminar_2a_private.id
 route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_association_2b" {
 subnet_id = aws_subnet.Seminar_2b_private.id
 route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_association_2c" {
 subnet_id = aws_subnet.Seminar_2c_private.id
 route_table_id = aws_route_table.private_route_table.id
}


# Network ACL

# SG(Security Group)

