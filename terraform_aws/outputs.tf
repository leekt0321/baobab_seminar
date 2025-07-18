output "apply_success_node" {
  description = "성공적으로 완료시 안내 메시지"
  value = <<EOT
  성공적으로 배포 완료됨.

  <접속 안내>
  * bastion에서 connector로 접속하기 위해서는 'scp -i seminar_key.pem connector_key.pem ec2-user@<bastion_public_ip>:~' 입력 필수
  * bastion에서 mediator로 접속하기 위해서는 'scp -i seminar_key.pem mediator_key.pem ec2-user@<bastion_public_ip>:~' 입력 필수
  1. bastion 접속: ssh -i seminar_key.pem ec2-user@<bastion_public_ip>
  2. connector 접속 및 테스트
     접속: ssh -i seminar_key.pem ec2-user@<bastion_public_ip>
          ssh -i connector_key.pem ubuntu@<connector_private_ip>
     테스트: ping 8.8.8.8
            curl -s https://google.com (EX: 301 Moved로 뜨면 정상)
  
  EOT
}
output "bastion_public_ip" {
  value = module.EC2.bastion_public_ip
}

output "cvo_mgmt_ip" {
  value = module.CVO_AWS.cvo_mgmt_ip
}