# CVO EC2 - HA 구성
terraform {
  required_providers {
    netapp-cloudmanager = {
      source = "netApp/netapp-cloudmanager"
      version = "~> 25.3.0"
    }
  }
}

resource "netapp-cloudmanager_cvo_aws" "cvo-aws" {
  provider = netapp-cloudmanager
  name = "terraformCVO"
  region = var.aws_region
  subnet_id = var.Seminar_2c_private_id
  vpc_id = var.Seminar_VPC_id
  svm_password = var.svm_password
  client_id = var.CVO_connector_aws_client_id
  is_ha = true
  failover_mode = "FloatingIP"    # PrivateIP - 단일 AZ, FloatingIP - 여러 AZ를 위한 것.
  node1_subnet_id = var.Seminar_2a_private_id
  node2_subnet_id = var.Seminar_2c_private_id
  mediator_subnet_id = var.Seminar_2c_private_id
  mediator_key_pair_name = var.aws_mediator_key
  cluster_floating_ip = "192.168.0.100"  # 서브넷 외부에 있는 프라이빗 IP 대역이여야 함
  data_floating_ip = "192.168.0.101"
  data_floating_ip2 = "192.168.0.102"
  route_table_ids = [var.private_route_table_id,var.public_route_table_id ] # CVO HA환경에선 Floating IP로 접속 가능해야 함
  license_type = "ha-capacity-paygo"  # 용량기반 비용청구, 기능 제한 있음 , 그리고 해당 licence를 aws marketplace에서 구독해야함.(노드 기반 청구는 지원 중단됨)
                                         # 구독 목록: netapp bluexp --> (변경) netapp intelligent services
                                         # 구독 후 위로 스크롤 후 set up your account 선택해 계정과 연결
  instance_type = "m5.xlarge" # default: m5.2xlarge. 비용최소화를 위해 explore로 선택
  ebs_volume_size_unit = "GB"
  ebs_volume_size = 500
  mediator_instance_profile_name = var.cvo_connector_EC2_profile_name
}