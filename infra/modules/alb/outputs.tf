output "alb_dns" {
    description = "alb's dns name"
    value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
    description = "alb's zone id"
    value = aws_lb.alb.zone_id
}

output "alb_tg_arn" {
    description = "alb's target group arn"
    value = aws_lb_target_group.gatus_tg.arn  
}

output "alb_arn" {
    description = "alb arn"
    value = aws_lb.alb.arn
}