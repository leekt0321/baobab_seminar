* CVO 구성하는 방법
1) NetApp 공식 Provider(o) - 채택
  -> NetApp Cloud Manager 계정 필요
  -> NetApp Terraform Provider 설치 필요

2) 수동 EC2 배포 후 CVO 설치(X)
   -> 복잡
   -> 그냥 ec2 생성 후 AMI로 구성하는 것.


provider "netapp-cloudmanager" {
  refresh_token         = var.cloudmanager_refresh_token     
  sa_secret_key         = var.cloudmanager_sa_secret_key    -> refresh_token을 사요하면 없어도 됌
  sa_client_id          = var.cloudmanager_sa_client_id
  aws_profile           = var.cloudmanager_aws_profile       -> 지정하지 않으면 default로 지정
  aws_profile_file_path = var.cloudmanager_aws_profile_file_path  -> Default로 ~/.aws/credentials에 있고, access key, secret key가 들어있으면 없어도 됌
  azure_auth_methods    = var.cloudmanager_azure_auth_methods  -> azure 사용 시 사용
}

  <접속 안내>
  * bastion에서 connector로 접속하기 위해서는 'scp -i seminar_key.pem connector_key.pem ec2-user@<bastion_public_ip>:~' 입력 필수
  * bastion에서 mediator로 접속하기 위해서는 'scp -i seminar_key.pem mediator_key.pem ec2-user@<bastion_public_ip>:~' 입력 필수

  1. bastion 접속: ssh -i seminar_key.pem ec2-user@<bastion_public_ip>
  2. connector 접속 및 테스트
     접속: ssh -i seminar_key.pem ec2-user@<bastion_public_ip>
           ssh -i connector_key.pem ubuntu@<connector_private_ip>
     테스트: ping 8.8.8.8
            curl -s https://google.com (EX: 301 Moved로 뜨면 정상)
  3. CVO 접속
     접속: ssh -i seminar_key.pem ec2-user@<bastion_public_ip>
           ssh -i mediator_key.pem admin@<CVO_private_ip>

      CVO의 private IP가 4개 있을 것.
      1. cluster mgmt ip
      2. node mgmt ip
      3. cluster inter ip
      4. data ip(nfs/cifs/iscsi)