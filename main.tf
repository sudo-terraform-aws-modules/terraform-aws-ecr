data "aws_region" "current" {}

resource "aws_ecr_repository" "repo" {
  name                 = local.repo_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.encryption_type == "KMS" ? var.kms_key : null
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "policy" {
  repository = aws_ecr_repository.repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.keep_count} tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = [var.default_tag, "v"]
          countType     = "imageCountMoreThan"
          countNumber   = var.keep_count
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Expire untagged images older than ${var.untagged_expiry_days} days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.untagged_expiry_days
        }
        action = { type = "expire" }
      }
    ]
  })
}

resource "aws_ecr_repository_policy" "policy" {
  count = var.repository_policy != null ? 1 : 0

  repository = aws_ecr_repository.repo.name
  policy     = var.repository_policy
}

# Seed the repository with a default image.
# Requires Docker and AWS CLI on the machine running Terraform.
resource "null_resource" "push" {
  count = var.init_repo ? 1 : 0

  triggers = {
    repo = aws_ecr_repository.repo.repository_url
  }

  provisioner "local-exec" {
    command     = "${local.init_script} ${data.aws_region.current.region} ${var.default_container} ${aws_ecr_repository.repo.repository_url}:${var.default_tag}"
    interpreter = ["bash", "-c"]
  }
}
