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

variable "vpc_id" {
    type = string  
}

variable "public_subnet_ids" {
    type = list(string)
}

variable "alb_sg" {
    type = string
}

variable "acm_validation_certificate" {
    type = string
}