
resource "aws_instance" "master" {

  key_name      = local.key_pair

  ami           = local.ami_id
  
  instance_type = "t3.medium"

  tags          = local.tags

  vpc_security_group_ids = local.security_group_ids

  subnet_id = local.subnet_id
}

resource "aws_instance" "node01" {

  key_name      = local.key_pair

  ami           = local.ami_id

  instance_type = "t3.medium"

  tags          = local.tags

  vpc_security_group_ids = local.security_group_ids

  subnet_id = local.subnet_id

}

output "master_ip" {
  value = aws_instance.master.private_ip
}

output "node01_ip" {
  value = aws_instance.node01.private_ip
}