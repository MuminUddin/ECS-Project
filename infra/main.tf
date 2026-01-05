module "vpc" {
  source         = "./modules/vpc"
  common_tags    = var.common_tags
  vpc_cidr_block = var.vpc_cidr_block
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source                     = "./modules/alb"
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  alb_sg                     = module.security.alb_sg
  acm_validation_certificate = module.acm.acm_validation_certificate
}

module "acm" {
  source      = "./modules/acm"
  alb_dns     = module.alb.alb_dns
  alb_zone_id = module.alb.alb_zone_id
}

module "ecr" {
  source      = "./modules/ecr"
  common_tags = var.common_tags
  repo_name   = "gatus-ecr"
}

module "ecs" {
  source             = "./modules/ecs"
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_task_sg        = module.security.ecs_task_sg
  alb_tg_arn         = module.alb.alb_tg_arn
  ecr_repository_url = module.ecr.repository_url
}