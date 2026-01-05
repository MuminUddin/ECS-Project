# Create iam role and attachment
resource "aws_iam_role" "ecs_task_iam_role" {
  name = "ecs_task_iam_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "gatus-iam-role"
  })
}

resource "aws_iam_role_policy_attachment" "ecs_iam_attachment" {
  role       = aws_iam_role.ecs_task_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create ecs-cluster
resource "aws_ecs_cluster" "gatus_cluster" {
  name = "gatus-cluster"

  tags = merge(var.common_tags, {
    Name = "gatus-ecs-cluster"
  })
}

# Create CloudWatch log group
resource "aws_cloudwatch_log_group" "gatus_cloudwatch" {
  name              = "/ecs/gatus-task"
  retention_in_days = var.retention_days

  tags = merge(var.common_tags, {
    Name = "gatus-cloudwatch-log"
  })
}

# Create ecs task definition
resource "aws_ecs_task_definition" "gatus_task_def" {
  family                   = "gatus-task-def"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_iam_role.arn
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions    = <<TASK_DEFINITION
  [
    {
        "name": "gatus-task",
        "image": "${var.ecr_repository_url}:${var.image_tag}",
        "essential": true,
        "portMappings": [
            {
                "containerPort": ${var.container_port},
                "protocol": "tcp"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/gatus-task",
                "awslogs-region": "${var.region}",
                "awslogs-stream-prefix": "ecs"
                }
            }
    }
  ]
  TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  tags = merge(var.common_tags, {
    Name = "gatus-task"
  })
}

# Create cluster service
resource "aws_ecs_service" "gatus_ecs_service" {
  name            = "gatus-ecs-service"
  cluster         = aws_ecs_cluster.gatus_cluster.arn
  task_definition = aws_ecs_task_definition.gatus_task_def.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups  = [var.ecs_task_sg]
  }

  load_balancer {
    container_name   = "gatus-task"
    container_port   = var.container_port
    target_group_arn = var.alb_tg_arn
  }

  tags = merge(var.common_tags, {
    Name = "gatus-ecs-service"
  })
}