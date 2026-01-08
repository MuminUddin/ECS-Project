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
  default     = "10.0.0.0/16"
}

variable "image_tag" {
  type = string
  default = "latest"
}