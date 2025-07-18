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

module "VPC" {
  source = "./modules/VPC"
}

module "Key-pair" {
  source = "./modules/Key-pair"
}

module "IAM" {
  source = "./modules/IAM"
  depends_on = [ module.VPC ]
}

module "EC2" {
  source = "./modules/EC2"
  Seminar_2a_public = module.VPC.Seminar_2a_public_id
  bastion_key = module.Key-pair.bastion_key_keyname
  security_group = module.VPC.bastion_sg_id
  depends_on = [ module.IAM ]
}

module "CVO_Connector" {
  source = "./modules/CVO_Connector"
  Seminar_2a_private_id = module.VPC.Seminar_2a_private_id
  security_group_id = module.VPC.security_group_id
  cvo_connector_EC2_profile_name = module.IAM.cvo_connector_EC2_profile_name
  depends_on = [ module.EC2 ]
}

module "CVO_AWS" {
  source = "./modules/CVO_AWS"
  svm_password = var.svm_password
  Seminar_2c_private_id = module.VPC.Seminar_2c_private_id
  Seminar_2a_private_id = module.VPC.Seminar_2a_private_id
  Seminar_VPC_id = module.VPC.Seminar_VPC_id
  CVO_connector_aws_client_id = module.CVO_Connector.CVO_connector_aws_client_ID
  cvo_connector_EC2_profile_name = module.IAM.cvo_connector_EC2_profile_name
  public_route_table_id = module.VPC.public_route_table_id
  private_route_table_id = module.VPC.private_route_table_id
  depends_on = [ module.CVO_Connector ]
}