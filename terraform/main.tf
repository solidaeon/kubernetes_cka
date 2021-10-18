


resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.example.cidr_block]
  ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = "sg-123456"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  ipv6_cidr_blocks  = local.my_ip_cidr
  security_group_id = "sg-123456"
}

resource "aws_instance" "kubernetes" {
  count         = local.count
  
  ami           = local.ami_id
  
  instance_type = "t3.medium"

  tags          = local.tags

  vpc_security_group_ids = []
}