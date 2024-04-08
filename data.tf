data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  provider = aws.region
}

locals {
  account_id  = data.aws_caller_identity.current.account_id
  region_name = data.aws_region.current.name
}