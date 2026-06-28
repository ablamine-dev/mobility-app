data "aws_iam_role" "ecs_execution" {
  name = "ecsTaskExecutionRole"
}

data "aws_ecs_cluster" "main" {
  cluster_name = "mobility-cluster-ecs"
}

locals {
  backend_image = "825187895423.dkr.ecr.eu-west-3.amazonaws.com/mobility-backend:latest"
}

# Groupe de logs CloudWatch pour voir ce que dit le conteneur
resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/${var.project_name}-backend-tf"
  retention_in_days = 7

  tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.project_name}-backend-tf"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = "mobility-backend"
      image     = local.backend_image
      essential = true

      portMappings = [
        { containerPort = 5000, protocol = "tcp" }
      ]

      environment = [
        { name = "PORT", value = "5000" }
      ]

      secrets = [
        { name = "MONGO_URI", valueFrom = aws_secretsmanager_secret.mongo_uri.arn }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}-backend-tf"
          "awslogs-region"        = "eu-west-3"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}

resource "aws_ecs_service" "backend" {
  name            = "${var.project_name}-backend-service-tf"
  cluster         = data.aws_ecs_cluster.main.arn
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.backend.id]
    assign_public_ip = true
  }

  tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}

output "backend_task_definition_arn" {
  value = aws_ecs_task_definition.backend.arn
}

output "backend_service_name" {
  value = aws_ecs_service.backend.name
}