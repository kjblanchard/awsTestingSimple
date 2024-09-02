
data "aws_s3_object" "network_json" {
  bucket = "supergoon-network-outputs-${var.account_id}"
  key    = "network/outputs.json"
}

locals {
  json_network_data  = jsondecode(data.aws_s3_object.network_json.body)
  vpc                = local.json_network_data.vpc
  vpc_id             = local.vpc.id
  subnets            = local.json_network_data.subnets
  public_subnets     = local.subnets.public
  public_subnet_ids  = [for subnet in local.public_subnets : subnet.id]
  private_subnets    = local.subnets.private
  private_subnet_ids = [for subnet in local.private_subnets : subnet.id]
}
