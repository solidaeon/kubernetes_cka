locals {

  ami_id = "ami-0df99b3a8349462c6"

  key_pair = "jp-devops-asurion-poc-apne1-keypair"

  my_ip_cidr = ["154.21.216.228"]

  tags = {
    BUSINESS_UNIT="PSS"
    BUSINESS_REGION="GK"
    PLATFORM="JP_TOOLS"
    CLIENT="MULTI_TENANT"
    "SLEEP:SCHEDULER"="ALTERNATIVE"
  }

}