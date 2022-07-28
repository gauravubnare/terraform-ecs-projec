provider "aws" {
  region = "eu-west-2"
}

module "ecr" {
  source = "./ecr"
}

module "vpc" {
  source = "./vpc"
}

module "elb" {
  source   = "./elb"
  alb_sg   = module.vpc.alb_sg
  vpc_id   = module.vpc.vpc_id
  subnet01 = module.vpc.subnet01
  subnet02 = module.vpc.subnet02
  acm_arn = var.acm_arn
}

module "ecs" {
  source       = "./ecs"
  ecs_image_id = var.image_id
  tg_arn       = module.elb.tg_arn
  ecs_sg       = module.vpc.ecs_sg
  subnet01     = module.vpc.subnet01
  subnet02     = module.vpc.subnet02
  depends_on = [
    module.elb
  ]
}

module "route53" {
  source       = "./route53"
  domain = var.domain
  sns-email = var.sns-email
  depends_on = [
    module.elb
  ]
}

