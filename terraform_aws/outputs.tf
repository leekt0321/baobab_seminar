# output.tf
output "instance_public_ip"{
  description = "EC2 인스턴스 퍼블릭 IP 주소"
  value = aws_instance.bastion_ec2.public_ip
}

output "Bastion_private_key" { // key 값 노출 방지
  value = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "Connector_private_key(If you in connector, do scp -i seminar-key.pem connector_key.pem ec2-user@<Bastion Public IP>)" { // key 값 노출 방지
  value = tls_private_key.ssh_connector_key.private_key_pem
  sensitive = true
}