output "repository_url" {
    description = "url for ecr repo"
    value = aws_ecr_repository.gatus_ecr.repository_url
}