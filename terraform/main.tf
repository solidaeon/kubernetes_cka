
resource "aws_security_group" "master_sg" {
  name = "kubernetes-hw-master-sg"
  vpc_id = local.vpc_id
  tags = local.tags
}
resource "aws_security_group_rule" "master_sg_ingress_1" {
  from_port = 6443
  description = "Kubernetes API server"
  protocol = "tcp"
  security_group_id = aws_security_group.master_sg.id
  to_port = 6443
  type = "ingress"
  cidr_blocks = local.allowed_cidr
}
resource "aws_security_group_rule" "master_sg_ingress_2" {
  from_port = 2379
  description = "etcd server client API"
  protocol = "tcp"
  security_group_id = aws_security_group.master_sg.id
  to_port = 2380
  type = "ingress"
  cidr_blocks = local.allowed_cidr
}
resource "aws_security_group_rule" "master_sg_ingress_3" {
  from_port = 10250
  description = "kubelet, kube-scheduler, kube-controller-manager"
  protocol = "tcp"
  security_group_id = aws_security_group.master_sg.id
  to_port = 10252
  type = "ingress"
  cidr_blocks = local.allowed_cidr
}
resource "aws_security_group_rule" "master_sg_engress" {
  from_port = 0
  protocol = -1
  security_group_id = aws_security_group.master_sg.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/9"]
}

resource "aws_instance" "master" {

  key_name      = local.key_pair

  ami           = local.ami_id
  
  instance_type = "t3.medium"

  tags          = local.tags

  vpc_security_group_ids = concat(local.security_group_ids, [aws_security_group.master_sg.id])

  subnet_id = local.subnet_id
}

resource "aws_security_group" "worker_sg" {
  name = "kubernetes-hw-worker-sg"
  vpc_id = local.vpc_id
  tags = local.tags
}
resource "aws_security_group_rule" "worker_sg_ingress_1" {
  from_port = 10250
  description = "kubelet"
  protocol = "tcp"
  security_group_id = aws_security_group.worker_sg.id
  to_port = 10250
  type = "ingress"
  cidr_blocks = local.allowed_cidr
}
resource "aws_security_group_rule" "worker_sg_ingress_2" {
  from_port = 30000
  description = "kubelet"
  protocol = "tcp"
  security_group_id = aws_security_group.worker_sg.id
  to_port = 32767
  type = "ingress"
  cidr_blocks = local.allowed_cidr
}
resource "aws_security_group_rule" "worker_sg_engress" {
  from_port = 0
  protocol = -1
  security_group_id = aws_security_group.worker_sg.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/9"]
}

resource "aws_instance" "worker_node" {

  count         = local.worker_node_count

  key_name      = local.key_pair

  ami           = local.ami_id

  instance_type = "t3.medium"

  tags          = local.tags

  vpc_security_group_ids = concat(local.security_group_ids, [aws_security_group.worker_sg.id])

  subnet_id = local.subnet_id

}

output "master_ip" {
  value = aws_instance.master.private_ip
}

output "node01_ip" {
  value = aws_instance.worker_node.*.private_ip
}