resource "aws_ecr_repository" "repo" {
  name                 = local.repo_name
  image_tag_mutability = var.image_tag_mutability
}
resource "aws_ecr_lifecycle_policy" "policy" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 versioned images and '${var.default_tag}' tagged image.",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": [
                    "${var.default_tag}",
                    "v"
                ],
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 3,
            "description": "Keep last 3 any images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 3
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

data "aws_region" "current" {}

# Initialize Repo
#  $1 Region Name - data.aws_region.current.name
#  $2 default container repo
#  $3 ECR repo
resource "null_resource" "push" {
  count = var.init_repo == true ? 1 : 0
  triggers = {
    repo = aws_ecr_repository.repo.repository_url
  }

  provisioner "local-exec" {
    command     = "${local.init_script} ${data.aws_region.current.name} ${var.default_container} ${aws_ecr_repository.repo.repository_url}:${var.default_tag}"
    interpreter = ["bash", "-c"]
  }
}
