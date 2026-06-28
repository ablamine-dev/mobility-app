resource "aws_secretsmanager_secret" "mongo_uri" {
  name        = "${var.project_name}/mongo-uri"
  description = "URI de connexion MongoDB pour l'API mobility"

  tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}

resource "aws_secretsmanager_secret_version" "mongo_uri" {
  secret_id     = aws_secretsmanager_secret.mongo_uri.id
  secret_string = var.mongo_uri
}

resource "aws_iam_role_policy" "ecs_read_mongo_secret" {
  name = "read-mongo-uri-secret"
  role = "ecsTaskExecutionRole"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "secretsmanager:GetSecretValue"
        Resource = aws_secretsmanager_secret.mongo_uri.arn
      }
    ]
  })
}

output "mongo_uri_secret_arn" {
  value = aws_secretsmanager_secret.mongo_uri.arn
}