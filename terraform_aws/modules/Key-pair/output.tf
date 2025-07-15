output "bastion_key_keyname" {
  value = aws_key_pair.bastion_key.key_name
}

output "ssh_connector_key" {
  value = aws_key_pair.connector_key
}

output "ssh_mediator_key" {
  value = aws_key_pair.mediator_key
}