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

terraform {
  // terraform 버전이 1.0.0버전 이상 2.0.0버전 미만
  required_version = ">= 1.0.0, < 2.0.0"
  
  required_providers {
  netapp-cloudmanager = {
    // netapp-cloudmanager 25.3.0버전
    source = "NetApp/netapp-cloudmanager"
    version = "~> 25.3.0"
    }
  aws = {
    source = "hashicorp/aws"
    // aws provider 버전이 4.0버전 이상인 경우 실행
    version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}

provider "netapp-cloudmanager" {
  refresh_token = var.refresh_token
  
}

# CVO Connector

# CVO EC2

