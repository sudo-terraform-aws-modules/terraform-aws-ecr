output "repository_url" {
  value       = aws_ecr_repository.repo.repository_url
  description = "ECR Repo URL"
}

output "name" {
  value       = aws_ecr_repository.repo.name
  description = "ECR Repo Name"
}

output "arn" {
  value       = aws_ecr_repository.repo.arn
  description = "ECR Repo ARN"
}

output "default_image" {
  value       = "${aws_ecr_repository.repo.repository_url}:${var.default_tag}"
  description = "Default image in ECR Repo"
}
