variable "common_tags" {
  type = map(string)
  default = {
    Project     = "gatus-ecs-project"
    Environment = "prod"
  }
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "task_cpu" {
  description = "task definition cpu"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "task definition memory"
  type        = number
  default     = 1024
}

variable "retention_days" {
  type    = number
  default = 7
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "ecs_task_sg" {
    type = string
}

variable "alb_tg_arn" {
    type = string
}

variable "ecr_repository_url" {
    type = string
}

variable "image_tag" {
  type = string
  default = "latest"
}