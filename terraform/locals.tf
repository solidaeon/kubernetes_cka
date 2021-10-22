locals {

  master_node_count = 1

  worker_node_count = 2

  ami_id = "ami-0df99b3a8349462c6"

  key_pair = "jp-devops-asurion-poc-apne1-keypair"

  vpc_id = "vpc-5c064639"

  allowed_cidr = ["100.103.136.0/21", "10.0.0.0/8"]

  security_group_ids = ["sg-61d44018"]

  subnet_id = "subnet-3c624e4b"

  tags = {
    BUSINESS_UNIT="PSS"
    BUSINESS_REGION="GK"
    PLATFORM="JP_TOOLS"
    CLIENT="MULTI_TENANT"
    "SLEEP:SCHEDULER"="ALTERNATIVE"
    PURPOSE="CKA_TRAINING_INSTANCE"
  }

}