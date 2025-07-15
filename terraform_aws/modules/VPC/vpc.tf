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