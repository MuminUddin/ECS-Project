output "ecs_cluster_name" {
    value = aws_ecs_cluster.gatus_cluster.name
}

output "aws_ecs_task_definition_arn" {
    value = aws_ecs_task_definition.gatus_task_def.arn  
}

output "ecs_service_name" {
    value = aws_ecs_service.gatus_ecs_service.name
}