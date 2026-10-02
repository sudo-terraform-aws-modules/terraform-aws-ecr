output "name" {
  value       = aws_ecr_repository.repo.name
  description = "ECR repository name"
}

output "arn" {
  value       = aws_ecr_repository.repo.arn
  description = "ECR repository ARN"
}

output "registry_id" {
  value       = aws_ecr_repository.repo.registry_id
  description = "ECR registry ID (AWS account ID)"
}

output "repository_url" {
  value       = aws_ecr_repository.repo.repository_url
  description = "ECR repository URL"
}

output "default_image" {
  value       = "${aws_ecr_repository.repo.repository_url}:${var.default_tag}"
  description = "Full URI of the default tagged image"
}
