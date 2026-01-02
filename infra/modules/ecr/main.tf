resource "aws_ecr_repository" "gatus_ecr" {
  name = var.repo_name
  image_tag_mutability = "MUTABLE"

  tags = merge(var.common_tags, {
    Name = "gatus-ecr"
  })
}