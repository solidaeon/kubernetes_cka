
resource "aws_instance" "kubernetes" {

  count         = local.count
  
  ami           = local.ami_id
  
  instance_type = "t3.medium"

  tags          = local.tags

  vpc_security_group_ids = local.security_group_ids

  subnet_id = local.subnet_id
}