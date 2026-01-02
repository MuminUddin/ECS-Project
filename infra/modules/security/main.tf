resource "aws_security_group" "alb_sg" {
  vpc_id      = var.vpc_id
  name        = "alb-sg"
  description = "allows http and https inbound traffic and allows all outbound traffic"

  tags = merge(var.common_tags, {
    Name = "gatus-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = var.all_traffic_cidr
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = merge(var.common_tags, {
    Name = "gatus-alb-sg-https"
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = var.all_traffic_cidr
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = merge(var.common_tags, {
    Name = "gatus-alb-sg-http"
  })
}

resource "aws_vpc_security_group_egress_rule" "alb_outbound" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = var.all_traffic_cidr
  ip_protocol       = "-1"

  tags = merge(var.common_tags, {
    Name = "gatus-alb-sg-outbound"
  })
}

# Create ecs-task security group
resource "aws_security_group" "ecs_task_sg" {
  vpc_id      = var.vpc_id
  name        = "ecs-task-sg"
  description = "inbound traffic from alb_sg only, outbound traffic to anywhere"

  tags = merge(var.common_tags, {
    Name = "gatus-task-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb_traffic" {
  security_group_id            = aws_security_group.ecs_task_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = var.container_port
  ip_protocol                  = "tcp"
  to_port                      = var.container_port

  tags = merge(var.common_tags, {
    Name = "gatus-task-sg-inbound"
  })
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.ecs_task_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = var.all_traffic_cidr

  tags = merge(var.common_tags, {
    Name = "ecs-task-sg-outbound"
  })
}