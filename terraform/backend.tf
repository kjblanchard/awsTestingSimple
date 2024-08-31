terraform {
  backend "s3" {
    bucket = "supergoon-terraform-plans"
    key    = "aws/webserver/terraform.tfstate"
    region = "us-east-2"
  }
}