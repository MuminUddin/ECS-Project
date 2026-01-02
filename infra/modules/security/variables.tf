variable "common_tags" {
  type = map(string)
  default = {
    Project     = "gatus-ecs-project"
    Environment = "prod"
  }
}

variable "all_traffic_cidr" {
    type = string
    description = "cidr block for all traffic"
    default = "0.0.0.0/0"  
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "vpc_id" {
    type = string  
}