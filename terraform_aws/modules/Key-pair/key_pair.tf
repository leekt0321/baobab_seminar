
# key-pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_key" {
  key_name   = var.aws_bastion_key
  public_key = tls_private_key.ssh_key.public_key_openssh
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


resource "local_file" "bastion_private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "seminar-key.pem"
  file_permission = "0400"
}

resource "local_file" "connector_private_key" {
  content         = tls_private_key.ssh_connector_key.private_key_pem
  filename        = "connector-key.pem"
  file_permission = "0400"
}

resource "local_file" "mediator_private_key" {
  content         = tls_private_key.ssh_mediator_key.private_key_pem
  filename        = "mediator-key.pem"
  file_permission = "0400"
}

