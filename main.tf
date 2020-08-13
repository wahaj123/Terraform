data "aws_availability_zones" "azs" {}

data "aws_ssm_parameter" "name" {
  name = "Dbname"
}
data "aws_ssm_parameter" "password" {
  name = "db_password"
}

module "my_vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = var.vpc_cidr
  public_subnet     = var.public_subnet
  private_subnet    = var.private_subnet
  availability_zone = data.aws_availability_zones.azs.names
}

module "my_ec2" {
  source        = "./modules/Ec2"
  ec2_count     = 2
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = "${module.my_vpc.private_subnets_ids}"
  key_name      = var.key_name
  vpc_id        = "${module.my_vpc.vpc_id}"
  rds_endpoint  = "${module.db.rds_endpoint}"
  name          = data.aws_ssm_parameter.name.value
  username      = data.aws_ssm_parameter.name.value
  password      = data.aws_ssm_parameter.password.value
  alb_sg        = "${module.alb.alb_sg}"
  bastion_sg    = "${module.bastion.bastion_sg}"
}

module "db" {
  source            = "./modules/Rds"
  ec2_sg            = "${module.my_ec2.ec2_sg}"
  allocated_storage = var.db_allocated_storage
  storage_type      = var.db_storage_type
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  name              = data.aws_ssm_parameter.name.value
  username          = data.aws_ssm_parameter.name.value
  password          = data.aws_ssm_parameter.password.value
  vpc_id            = "${module.my_vpc.vpc_id}"
  public_subnet     = "${module.my_vpc.public_subnets_ids}"
}
module "alb" {
  source        = "./modules/alb"
  vpc_id        = "${module.my_vpc.vpc_id}"
  ec2_instance  = "${module.my_ec2.ec2_instance}"
  public_subnet = "${module.my_vpc.public_subnets_ids}"
}
module "bastion" {
  source        = "./modules/bastion-host"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = "${module.my_vpc.public_subnets_ids[0]}"
  key_name      = var.key_name
  vpc_id        = "${module.my_vpc.vpc_id}"
}
module "route53" {
  source  = "./modules/route53"
  alb_dns = "${module.alb.alb_dns}"
  zone_id = "${module.alb.zone_id}"
  vpc_id  = "${module.my_vpc.vpc_id}"
}
