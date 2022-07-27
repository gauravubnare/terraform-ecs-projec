resource "aws_ecr_repository" "rolax-repo" {
  name                 = "rolax-repo"
  image_tag_mutability = "MUTABLE"
}