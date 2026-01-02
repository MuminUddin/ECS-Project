variable "common_tags" {
  type = map(string)
  default = {
    Project     = "gatus-ecs-project"
    Environment = "prod"
  }
}

variable "region" {
  type    = string
  default = "eu-west-2"
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

variable "hosted_zone_name" {
  type        = string
  description = "name of hosted zone"
  default     = "muminlabs.com"
}

variable "subdomain" {
  type        = string
  description = "name of the subdomain"
  default     = "status"
}

locals {
  fqdn = "${var.subdomain}.${var.hosted_zone_name}"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr block for vpc"
}