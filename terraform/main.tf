resource "aws_ecr_repository" "frontend" {
  name                 = "mobility-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project   = "mobility"
    ManagedBy = "terraform"
  }
}

output "frontend_repository_url" {
  value = aws_ecr_repository.frontend.repository_url
}