# CVO.tf
/*

* CVO 구성하는 방법
1) NetApp 공식 Provider
  -> NetApp Cloud Manager 계정 필요
  -> NetApp Terraform Provider 설치 필요

2) 수동 EC2 배포 후 CVO 설치(X)
   -> 복잡
   -> 그냥 ec2 생성 후 AMI로 구성하는 것.

*/
/*
provider "netapp-cloudmanager" {
  refresh_token         = var.cloudmanager_refresh_token     
  sa_secret_key         = var.cloudmanager_sa_secret_key    -> refresh_token을 사요하면 없어도 됌
  sa_client_id          = var.cloudmanager_sa_client_id
  aws_profile           = var.cloudmanager_aws_profile       -> 지정하지 않으면 default로 지정
  aws_profile_file_path = var.cloudmanager_aws_profile_file_path  -> Default로 ~/.aws/credentials에 있고, access key, secret key가 들어있으면 없어도 됌
  azure_auth_methods    = var.cloudmanager_azure_auth_methods  -> azure 사용 시 사용
}
*/

provider "netapp-cloudmanager" {
  refresh_token = var.refresh_token
  
}

# IAM - connector policy를 가진 ID 생성
# IAM Role
resource "aws_iam_role" "cvo_connector_role" {
  name = "cvo_connector_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
  Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
})

  tags = {
    Name = "cvo_connector_role"
  }
}

# IAM Policy
resource "aws_iam_policy" "cvo_connector_policy" {
  name        = "cvo_connector_policy"
  description = "Policy for CVO Connector to manage EC2 and related resources"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:PutRolePolicy",
        "iam:CreateInstanceProfile",
        "iam:DeleteRolePolicy",
        "iam:AddRoleToInstanceProfile",
        "iam:RemoveRoleFromInstanceProfile",
        "iam:DeleteInstanceProfile",
        "iam:PassRole",
        "iam:ListRoles",
        "ec2:DescribeInstanceStatus",
        "ec2:RunInstances",
        "ec2:ModifyInstanceAttribute",
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:DescribeSecurityGroups",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeKeyPairs",
        "ec2:DescribeRegions",
        "ec2:DescribeInstances",
        "ec2:CreateTags",
        "ec2:DescribeImages",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeLaunchTemplates",
        "ec2:CreateLaunchTemplate",
        "cloudformation:CreateStack",
        "cloudformation:DeleteStack",
        "cloudformation:DescribeStacks",
        "cloudformation:DescribeStackEvents",
        "cloudformation:ValidateTemplate",
        "ec2:AssociateIamInstanceProfile",
        "ec2:DescribeIamInstanceProfileAssociations",
        "ec2:DisassociateIamInstanceProfile",
        "iam:GetRole",
        "iam:TagRole",
        "kms:ListAliases",
        "cloudformation:ListStacks"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:TerminateInstances"
      ],
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/OCCMInstance": "*"
        }
      },
      "Resource": [
        "arn:aws:ec2:*:*:instance/*"
      ]
    }
  ]
})
}

# IAM instance profile
/*
IAM Role을 EC2에 할당해줘야 하는데 인스턴스에 바로 역할을 붙이지 못 함.
역할을 인스턴스 프로파일에 연결하고, 프로파일을 ec2에 연결하는 식으로 부여
*/
resource "aws_iam_instance_profile" "cvo_connector_EC2_profile" {
  name = "connector_EC2_profile"
  role = aws_iam_role.cvo_connector_role.name
}

# IAM role policy attachment


# CVO connector key pair
resource "aws_key_pair" "connector_key" {
  key_name   = var.aws_connector_key
  public_key = tls_private_key.ssh_key.public_key_openssh
}


# CVO Connector
resource "netapp-cloudmanager_connector_aws" "CVO_connector_aws" {
  provider = netapp-cloudmanager
  name = "Terraform-ConnectorAWS"
  region = var.aws_region
  key_name = var.aws_connector_key
  company = "baobab"
  instance_type = "t3.xlarge"
  aws_tag {
              tag_key = "bluexp"
              tag_value = "CVO_connector"
            }
  subnet_id = aws_subnet.Seminar_2a_private.id
  security_group_id = aws_security_group.private_ec2_sg.id
  iam_instance_profile_name = aws_iam_instance_profile.cvo_connector_EC2_profile.name
}


# CVO EC2