variable "common_tags" {
  type = map(string)
  default = {
    Project     = "gatus-ecs-project"
    Environment = "prod"
  }
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

variable "alb_dns" {
    type = string
}

variable "alb_zone_id" {
    type = string
}