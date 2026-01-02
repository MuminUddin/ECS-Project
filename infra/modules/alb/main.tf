resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.public_subnet_ids

  tags = merge(var.common_tags, {
    Name = "gatus-alb"
  })
}

# Create target group for alb
resource "aws_lb_target_group" "gatus_tg" {
  name        = "gatus-tg"
  target_type = "ip"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
  }

  tags = merge(var.common_tags, {
    Name = "gatus-alb-tg"
  })
}

# Create alb listener
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(var.common_tags, {
    Name = "gatus-http-listener"
  })
}

resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  protocol          = "HTTPS"
  port              = 443
  certificate_arn   = var.acm_validation_certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gatus_tg.arn
  }

  tags = merge(var.common_tags, {
    Name = "gatus-https-listner"
  })
}

# Create /health path
resource "aws_lb_listener_rule" "health_check" {
  listener_arn = aws_lb_listener.alb_https_listener.arn
  priority     = 101
  condition {
    path_pattern {
      values = ["/health"]
    }
  }
  action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "{\"status\":\"ok\"}"
      status_code  = "200"
    }
  }
}