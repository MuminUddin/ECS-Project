output "alb_dns_name" {
  description = "name of the ALB DNS"
  value       = module.alb.alb_dns
}

output "final_url" {
  description = "final url for gatus app"
  value       = "https://${local.fqdn}"
}

output "ecr_repository_url" {
  description = "url for ecr repo"
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "name of the ecs cluster"
  value       = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  description = "name of ecs service"
  value       = module.ecs.ecs_service_name
}

output "tg_arn" {
  description = "target group arn"
  value       = module.alb.alb_tg_arn
}

output "task_def_arn" {
  description = "task definition arn"
  value       = module.ecs.aws_ecs_task_definition_arn
}