provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/OrganizationAccountAccessRole"
  }
  default_tags {
    tags = var.provider_tags
  }
}

provider "aws" {
  region = "us-east-1"
  alias = "r53"
  default_tags {
    tags = var.provider_tags
  }
}