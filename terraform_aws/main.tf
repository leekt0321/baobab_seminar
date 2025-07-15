# main.tf
terraform {
  // terraform 버전이 1.0.0버전 이상 2.0.0버전 미만
  required_version = ">= 1.0.0, < 2.0.0"
  
  required_providers {
  aws = {
    source = "hashicorp/aws"
    // aws provider 버전이 4.0버전 이상인 경우 실행
    version = "~> 5.0"
    }
  netapp-cloudmanager = {
    // netapp-cloudmanager 25.3.0버전
    source = "NetApp/netapp-cloudmanager"
    version = "~> 25.3.0"
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

provider "netapp-cloudmanager" {
  refresh_token = var.refresh_token
  
}

