module "webserver" {
  source              = "./webserver-module"
  aws_account         = local.account_id
  container_port      = var.container_port
  vpc_cidr            = var.vpc_cidr
  private_subnet_1    = var.private_subnet_1
  private_subnet_2    = var.private_subnet_2
  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
  public_subnet_1     = var.public_subnet_1
  public_subnet_2     = var.public_subnet_2
  domain              = var.domain
  sub-domain          = var.sub-domain
}