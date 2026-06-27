variable "aws_region" {
  description = "Région AWS où déployer les ressources"
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Nom du projet (préfixe et tag des ressources)"
  type        = string
  default     = "mobility"
}