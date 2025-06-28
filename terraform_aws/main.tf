terraform {
  // terraform 버전이 1.0.0버전 이상 2.0.0버전 미만
  required_version = ">= 1.0.0, < 2.0.0"
  
  required_providers {
  aws = {
    source = "hashicorp/aws"
    // aws provider 버전이 4.0버전 이상인 경우 실행
    version = "~> 5.0"
    }

  tls = {  // 암호화 키(예: TLS/SSH 키)와 인증서를 생성하는 기능을 제공
      source  = "hashicorp/tls"
      version = "~> 4.1"
    }
  }
}
provider "aws" {
region = var.aws_region
}

# VPC
resource "aws_vpc" "Seminar_VPC" {
  cidr_block = var.aws_VPC
  instance_tenancy = "default"

  tags = {
    Name = "Seminar_VPC"
  }
}

# Subnet
resource "aws_subnet" "Seminar_2a_public"{
  vpc_id = aws_vpc.Seminar_VPC.id
  cidr_block = var.aws_Seminar_2a_public_cidr
  availability_zone = var.aws_az_a
  tags = {
    Name = "Seminar_Subnet_public_2a"
  }
}
resource "aws_subnet" "Seminar_2a_private"{
  vpc_id = aws_vpc.Seminar_VPC.id
  cidr_block = var.aws_Seminar_2a_private_cidr
  availability_zone = var.aws_az_a
  tags = {
    Name = "Seminar_Subnet_private_2a"
  }
}

resource "aws_subnet" "Seminar_2c_private"{
  vpc_id = aws_vpc.Seminar_VPC.id
  cidr_block = var.aws_Seminar_2c_private_cidr
  availability_zone = var.aws_az_c
  tags = {
    Name = "Seminar_Subnet_private_2c"
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
  depends_on = [ aws_internet_gateway.Seminar_IGW ]
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

# Routing Table Association(private subnet) - 2a,2c
resource "aws_route_table_association" "private_association_2a" {
 subnet_id = aws_subnet.Seminar_2a_private.id
 route_table_id = aws_route_table.private_route_table.id
}


resource "aws_route_table_association" "private_association_2c" {
 subnet_id = aws_subnet.Seminar_2c_private.id
 route_table_id = aws_route_table.private_route_table.id
}


# SG(Security Group)
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.Seminar_VPC.id

  ingress {
    description = "SSH from anywhere (test only)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // 접속 허용할 범위 지정
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_sg"
  }
}

resource "aws_security_group" "private_ec2_sg" {
  name        = "private_ec2_sg"
  description = "Allow SSH from Bastion"
  vpc_id      = aws_vpc.Seminar_VPC.id

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] // bastion에서만 접근 허용 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private_ec2_sg"
  }
}

# key-pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_key" {
  key_name   = var.aws_bastion_key
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# EC2
resource "aws_instance" "bastion_ec2" {  # AMI는 계속 바뀌므로 data resource 사용 권장 지금은 test이므로 그냥 사용
  ami                         = "ami-0c593c3690c32e925" # Amazon Linux 2 (예시)
  instance_type               = var.aws_instance_type
  subnet_id                   = aws_subnet.Seminar_2a_public.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.bastion_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "BastionHost"
  }

  provisioner "local-exec" {  // 로컬에서 실행하는 것이고 bastion에서 실행되는 것이 아님. bastion에 키 전달은 수동으로 하는걸 권장, User Data로 전달은 보안상 위험
  ### terraform apply 후 해당 명령어 실행
  # scp -i seminar_key.pem seminar_key.pem ec2-user@<public_IP>:~
  ### 
    command = <<EOT
    echo "${tls_private_key.ssh_key.private_key_pem}" > seminar-key.pem
    chmod 400 seminar-key.pem
    echo "seminar-key.pem 생성 완료"
    EOT
    interpreter = [ "/bin/bash", "-c" ]
  }
}
