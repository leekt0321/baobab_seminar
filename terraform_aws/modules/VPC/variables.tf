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

variable "aws_az_a"{
    description = "AWS AZ 2a"
    type = string
    default = "us-east-2a"
}
variable "aws_az_c"{
    description = "AWS AZ 2c"
    type = string
    default = "us-east-2c"
}