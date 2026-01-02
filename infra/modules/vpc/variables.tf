variable "common_tags" {
  type = map(string)
  default = {
    Project     = "gatus-ecs-project"
    Environment = "prod"
  }
}

variable "vpc_cidr_block" {
    type = string
    description = "vpc's cidr block"
    default = "10.0.0.0/16"
}

variable "public_subnet1_cidr" {
    type = string
    description = "first public subnets cidr block"
    default = "10.0.1.0/24"
}

variable "public_subnet2_cidr" {
    type = string
    description = "second public subnets cidr block"
    default = "10.0.2.0/24"
}

variable "private_subnet1_cidr" {
    type = string
    description = "first private subnets cidr block"
    default = "10.0.3.0/24"  
}

variable "private_subnet2_cidr" {
    type = string
    description = "second private subnets cidr block"
    default = "10.0.4.0/24"  
}

variable "all_traffic_cidr" {
    type = string
    description = "cidr block for all traffic"
    default = "0.0.0.0/0"  
}