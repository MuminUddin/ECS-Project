resource "aws_ecr_repository" "gatus_ecr" {
  name = var.repo_name
  image_tag_mutability = "MUTABLE"
  force_delete = true

  tags = merge(var.common_tags, {
    Name = "gatus-ecr"
  })
}