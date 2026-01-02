output "ecs_task_sg" {
    description = "ecs task security group id"
    value = aws_security_group.ecs_task_sg.id
}

output "alb_sg" {
    description = "alb security group id"
    value = aws_security_group.alb_sg.id
}