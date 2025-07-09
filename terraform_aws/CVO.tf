# CVO.tf
/*

* CVO 구성하는 방법
1) NetApp 공식 Provider(o) - 채택
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

resource "aws_iam_role" "cvo_mediator_role" {
  name = "cvo_mediator_role"

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
    Name = "cvo_mediator_role"
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
        "iam:ListInstanceProfiles",
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

resource "aws_iam_policy" "cvo_connector_standard_region_1_policy" {
  name        = "cvo_connector_standard_region_1_policy"
  description = "Policy for CVO Connector to manage EC2 and related resources"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:RunInstances",
                "ec2:ModifyInstanceAttribute",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeRouteTables",
                "ec2:DescribeImages",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DescribeVolumes",
                "ec2:ModifyVolumeAttribute",
                "ec2:CreateSecurityGroup",
                "ec2:DescribeSecurityGroups",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DescribeDhcpOptions",
                "ec2:CreateSnapshot",
                "ec2:DescribeSnapshots",
                "ec2:GetConsoleOutput",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeRegions",
                "ec2:DescribeTags",
                "ec2:AssociateIamInstanceProfile",
                "ec2:DescribeIamInstanceProfileAssociations",
                "ec2:DisassociateIamInstanceProfile",
                "ec2:CreatePlacementGroup",
                "ec2:DescribeReservedInstancesOfferings",
                "ec2:AssignPrivateIpAddresses",
                "ec2:CreateRoute",
                "ec2:DescribeVpcs",
                "ec2:ReplaceRoute",
                "ec2:UnassignPrivateIpAddresses",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteSnapshot",
                "ec2:DeleteTags",
                "ec2:DeleteRoute",
                "ec2:DeletePlacementGroup",
                "ec2:DescribePlacementGroups",
                "ec2:DescribeVolumesModifications",
                "ec2:ModifyVolume",
                "cloudformation:CreateStack",
                "cloudformation:DescribeStacks",
                "cloudformation:DescribeStackEvents",
                "cloudformation:ValidateTemplate",
                "cloudformation:DeleteStack",
                "iam:PassRole",
                "iam:CreateRole",
                "iam:PutRolePolicy",
                "iam:CreateInstanceProfile",
                "iam:AddRoleToInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:ListInstanceProfiles",
                "iam:DeleteRole",
                "iam:DeleteRolePolicy",
                "iam:DeleteInstanceProfile",
                "iam:GetRolePolicy",
                "iam:GetRole",
                "sts:DecodeAuthorizationMessage",
                "sts:AssumeRole",
                "s3:GetBucketTagging",
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:CreateBucket",
                "s3:GetLifecycleConfiguration",
                "s3:ListBucketVersions",
                "s3:GetBucketPolicyStatus",
                "s3:GetBucketPublicAccessBlock",
                "s3:GetBucketPolicy",
                "s3:GetBucketAcl",
                "s3:PutObjectTagging",
                "s3:GetObjectTagging",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:PutObject",
                "s3:ListAllMyBuckets",
                "s3:GetObject",
                "s3:GetEncryptionConfiguration",
                "kms:List*",
                "kms:ReEncrypt*",
                "kms:Describe*",
                "kms:CreateGrant",
                "fsx:Describe*",
                "fsx:List*",
                "kms:GenerateDataKeyWithoutPlaintext"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "cvoServicePolicy"
        },
        {
            "Action": [
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:RunInstances",
                "ec2:TerminateInstances",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeImages",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSecurityGroup",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DescribeRegions",
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "kms:List*",
                "kms:Describe*",
                "ec2:DescribeVpcEndpoints",
                "kms:ListAliases",
                "athena:StartQueryExecution",
                "athena:GetQueryResults",
                "athena:GetQueryExecution",
                "glue:GetDatabase",
                "glue:GetTable",
                "glue:CreateTable",
                "glue:CreateDatabase",
                "glue:GetPartitions",
                "glue:BatchCreatePartition",
                "glue:BatchDeletePartition"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "backupPolicy"
        },
        {
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:CreateBucket",
                "s3:GetLifecycleConfiguration",
                "s3:PutLifecycleConfiguration",
                "s3:PutBucketTagging",
                "s3:ListBucketVersions",
                "s3:GetBucketAcl",
                "s3:PutBucketPublicAccessBlock",
                "s3:GetObject",
                "s3:PutEncryptionConfiguration",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject",
                "s3:PutBucketAcl",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts",
                "s3:DeleteBucket",
                "s3:GetObjectVersionTagging",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectRetention",
                "s3:GetObjectTagging",
                "s3:GetObjectVersion",
                "s3:PutObjectVersionTagging",
                "s3:PutObjectRetention",
                "s3:DeleteObjectTagging",
                "s3:DeleteObjectVersionTagging",
                "s3:GetBucketObjectLockConfiguration",
                "s3:GetBucketVersioning",
                "s3:PutBucketObjectLockConfiguration",
                "s3:PutBucketVersioning",
                "s3:BypassGovernanceRetention",
                "s3:PutBucketPolicy",
                "s3:PutBucketOwnershipControls"
            ],
            "Resource": [
                "arn:aws:s3:::netapp-backup-*"
            ],
            "Effect": "Allow",
            "Sid": "backupS3Policy"
        },
        {
            "Action": [
                "s3:CreateBucket",
                "s3:GetLifecycleConfiguration",
                "s3:PutLifecycleConfiguration",
                "s3:PutBucketTagging",
                "s3:ListBucketVersions",
                "s3:GetBucketPolicyStatus",
                "s3:GetBucketPublicAccessBlock",
                "s3:GetBucketAcl",
                "s3:GetBucketPolicy",
                "s3:PutBucketPublicAccessBlock",
                "s3:DeleteBucket"
            ],
            "Resource": [
                "arn:aws:s3:::fabric-pool*"
            ],
            "Effect": "Allow",
            "Sid": "fabricPoolS3Policy"
        },
        {
            "Action": [
                "ec2:DescribeRegions"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "fabricPoolPolicy"
        },
        {
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/netapp-adc-manager": "*"
                }
            },
            "Action": [
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:instance/*"
            ],
            "Effect": "Allow"
        },
        {
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/WorkingEnvironment": "*"
                }
            },
            "Action": [
                "ec2:StartInstances",
                "ec2:TerminateInstances",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:StopInstances",
                "ec2:DeleteVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:instance/*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "ec2:AttachVolume",
                "ec2:DetachVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*"
            ],
            "Effect": "Allow"
        },
        {
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/WorkingEnvironment": "*"
                }
            },
            "Action": [
                "ec2:DeleteVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:volume/*"
            ],
            "Effect": "Allow"
        }
    ]
})
}

resource "aws_iam_policy" "cvo_connector_standard_region_2_policy" {
  name        = "cvo_connector_standard_region_2_policy"
  description = "Policy for CVO Connector to manage EC2 and related resources"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeTags",
                "tag:getResources",
                "tag:getTagKeys",
                "tag:getTagValues",
                "tag:TagResources",
                "tag:UntagResources"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "tagServicePolicy"
        }
    ]
})
}

resource "aws_iam_policy" "base_CVO_node_policy" {
  name        = "base_CVO_node_policy"
  description = "base policy foro cvo ontap nodes"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
	"Statement": [{
			"Action": "s3:ListAllMyBuckets",
			"Resource": "arn:aws:s3:::*",
			"Effect": "Allow"
		}, {
			"Action": [
				"s3:ListBucket",
				"s3:GetBucketLocation"
			],
			"Resource": "arn:aws:s3:::fabric-pool-*",
			"Effect": "Allow"
		}, {
			"Action": [
				"s3:GetObject",
				"s3:PutObject",
				"s3:DeleteObject"
			],
			"Resource": "arn:aws:s3:::fabric-pool-*",
			"Effect": "Allow"
		}
	]
})
}

resource "aws_iam_policy" "backup_CVO_node_policy" {
  name        = "backup_CVO_node_policy"
  description = "backup policy for cv onodes"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::netapp-backup*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListAllMyBuckets",
                "s3:PutObjectTagging",
                "s3:GetObjectTagging",
                "s3:RestoreObject",
                "s3:GetBucketObjectLockConfiguration",
                "s3:GetObjectRetention",
                "s3:PutBucketObjectLockConfiguration",
                "s3:PutObjectRetention"
            ],
            "Resource": "arn:aws:s3:::netapp-backup*/*",
            "Effect": "Allow"
        }
    ]
})
}

resource "aws_iam_policy" "HA_mediator_policy" {
  name        = "HA_mediator_policy"
  description = "mediator policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
	"Statement": [{
			"Effect": "Allow",
			"Action": [
				"ec2:AssignPrivateIpAddresses",
				"ec2:CreateRoute",
				"ec2:DeleteRoute",
				"ec2:DescribeNetworkInterfaces",
				"ec2:DescribeRouteTables",
				"ec2:DescribeVpcs",
				"ec2:ReplaceRoute",
				"ec2:UnassignPrivateIpAddresses",
                "sts:AssumeRole",
                "ec2:DescribeSubnets"
			],
			"Resource": "*"
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

resource "aws_iam_instance_profile" "cvo_mediator_EC2_profile" {
  name = "mediator_EC2_profile"
  role = aws_iam_role.cvo_mediator_role.name
}

# IAM role policy attachment
resource "aws_iam_role_policy_attachment" "connector_attachment_1" {
  role = aws_iam_role.cvo_connector_role.name
  policy_arn = aws_iam_policy.cvo_connector_policy.arn
  
}

resource "aws_iam_role_policy_attachment" "connector_attachment_2" {
  role = aws_iam_role.cvo_connector_role.name
  policy_arn = aws_iam_policy.cvo_connector_standard_region_1_policy.arn
  
}
resource "aws_iam_role_policy_attachment" "connector_attachment_3" {
  role = aws_iam_role.cvo_connector_role.name
  policy_arn = aws_iam_policy.cvo_connector_standard_region_2_policy.arn
  
}

resource "aws_iam_role_policy_attachment" "mediator_attachment_1" {
  role = aws_iam_role.cvo_mediator_role.name
  policy_arn = aws_iam_policy.base_CVO_node_policy.arn
  
}

resource "aws_iam_role_policy_attachment" "mediator_attachment_2" {
  role = aws_iam_role.cvo_mediator_role.name
  policy_arn = aws_iam_policy.backup_CVO_node_policy.arn
  
}
resource "aws_iam_role_policy_attachment" "mediator_attachment_3" {
  role = aws_iam_role.cvo_mediator_role.name
  policy_arn = aws_iam_policy.HA_mediator_policy.arn
  
}


# key-pair
resource "tls_private_key" "ssh_connector_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# CVO connector key pair
resource "aws_key_pair" "connector_key" {
  key_name   = var.aws_connector_key
  public_key = tls_private_key.ssh_connector_key.public_key_openssh
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
  depends_on = [aws_internet_gateway.Seminar_IGW, aws_key_pair.connector_key]
}
resource "null_resource" "wait_for_connector" {
  depends_on = [ netapp-cloudmanager_connector_aws.CVO_connector_aws ]
  provisioner "local-exec" {
    command = "echo 'Waiting for connector'; sleep 30"
    
  }
}

# key-pair - mediator
resource "tls_private_key" "ssh_mediator_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# CVO mediator key pair
resource "aws_key_pair" "mediator_key" {
  key_name   = var.aws_mediator_key
  public_key = tls_private_key.ssh_mediator_key.public_key_openssh
}

# CVO EC2 - HA 구성
resource "netapp-cloudmanager_cvo_aws" "cvo-aws" {
  provider = netapp-cloudmanager
  name = "terraformCVO"
  region = var.aws_region
  subnet_id = aws_subnet.Seminar_2c_private.id
  vpc_id = aws_vpc.Seminar_VPC.id
  svm_password = var.svm_password
  client_id = netapp-cloudmanager_connector_aws.CVO_connector_aws.client_id
  is_ha = true
  failover_mode = "FloatingIP"    # PrivateIP - 단일 AZ, FloatingIP - 여러 AZ를 위한 것.
  node1_subnet_id = aws_subnet.Seminar_2a_private.id
  node2_subnet_id = aws_subnet.Seminar_2c_private.id
  mediator_subnet_id = aws_subnet.Seminar_2c_private.id
  mediator_key_pair_name = var.aws_mediator_key
  cluster_floating_ip = "192.168.0.100"  # 서브넷 외부에 있는 프라이빗 IP 대역이여야 함
  data_floating_ip = "192.168.0.101"
  data_floating_ip2 = "192.168.0.102"
  route_table_ids = [aws_route_table.private_route_table.id,aws_route_table.public_route_table.id ] # CVO HA환경에선 Floating IP로 접속 가능해야 함
  license_type = "ha-capacity-paygo"  # 용량기반 비용청구, 기능 제한 있음 , 그리고 해당 licence를 aws marketplace에서 구독해야함.(노드 기반 청구는 지원 중단됨)
                                         # 구독 목록: netapp bluexp --> (변경) netapp intelligent services
                                         # 구독 후 위로 스크롤 후 set up your account 선택해 계정과 연결
  instance_type = "m5.xlarge" # default: m5.2xlarge. 비용최소화를 위해 explore로 선택
  ebs_volume_size_unit = "GB"
  ebs_volume_size = 500
  mediator_instance_profile_name = aws_iam_instance_profile.cvo_connector_EC2_profile.name
  depends_on = [ netapp-cloudmanager_connector_aws.CVO_connector_aws , aws_key_pair.mediator_key,null_resource.wait_for_connector]
}