# output.tf
output "instance_public_ip"{
  description = "EC2 인스턴스 퍼블릭 IP 주소"
  value = aws_instance.bastion_ec2.public_ip
}

output "Bastion_private_key" { // key 값 노출 방지
  value = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "Connector_private_key" { // key 값 노출 방지
  value = tls_private_key.ssh_connector_key.private_key_pem
  sensitive = true
}

output "apply_success_node" {
  description = "성공적으로 완료시 안내 메시지"
  value = <<EOT
  성공적으로 배포 완료됨.

  <접속 안내>
  * bastion에서 connector로 접속하기 위해서는 'scp -i seminar_key.pem connector_key.pem ec2-user@<bastion_public_ip>:~' 입력 필수
  1. bastion 접속: ssh -i seminar_key.pem ec2-user@<bastion_public_ip>
  2. connector 접속 및 테스트
     접속: ssh -i seminar_key.pem ec2-user@<bastion_public_ip>
          ssh -i connector_key.pem ubuntu@<connector_private_ip>
     테스트: ping 8.8.8.8
            curl -s https://google.com (EX: 301 Moved로 뜨면 정상)
  
  EOT
}