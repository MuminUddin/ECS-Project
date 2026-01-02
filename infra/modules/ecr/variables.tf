variable "common_tags" {
  type = map(string)
  default = {
    Project     = "gatus-ecs-project"
    Environment = "prod"
  }
}

variable "repo_name" {
    type = string
    description = "ecr repository name"
    default = "gatus-ecr"
}