# SUDO AWS Terraform Module for ECR

Creates an AWS ECR repository with image scanning, encryption, lifecycle policies, and optional repository seeding.

## Usage

### Basic Repository

```hcl
module "ecr" {
  source  = "sudo-terraform-aws-modules/ecr/aws"
  version = "1.0.0"

  name = "my-app"
}
```

### Repository with KMS Encryption and Cross-Account Policy

```hcl
module "ecr" {
  source  = "sudo-terraform-aws-modules/ecr/aws"
  version = "1.0.0"

  name            = "my-app"
  encryption_type = "KMS"
  kms_key         = "arn:aws:kms:us-east-1:123456789012:key/my-key-id"

  repository_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowCrossAccountPull"
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::987654321098:root" }
      Action    = ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage"]
    }]
  })

  tags = { Environment = "prod" }
}
```

### Custom Lifecycle Policy Retention

```hcl
module "ecr" {
  source  = "sudo-terraform-aws-modules/ecr/aws"
  version = "1.0.0"

  name                 = "my-app"
  keep_count           = 10
  untagged_expiry_days = 7
  init_repo            = false
}
```

### Mutable Tags (for dev environments)

```hcl
module "ecr" {
  source  = "sudo-terraform-aws-modules/ecr/aws"
  version = "1.0.0"

  name                 = "my-app-dev"
  image_tag_mutability = "MUTABLE"
  init_repo            = false
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0, < 7.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1 |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_lifecycle_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [null_resource.push](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.random_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | ECR repository name | `string` | `null` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | Tag mutability: IMMUTABLE or MUTABLE | `string` | `"IMMUTABLE"` | no |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | Enable image vulnerability scanning on push | `bool` | `true` | no |
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | Encryption type: AES256 or KMS | `string` | `"AES256"` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | KMS key ARN for encryption (required when encryption_type is KMS) | `string` | `null` | no |
| <a name="input_repository_policy"></a> [repository\_policy](#input\_repository\_policy) | JSON repository policy for cross-account or cross-service access | `string` | `null` | no |
| <a name="input_keep_count"></a> [keep\_count](#input\_keep\_count) | Number of tagged images to retain | `number` | `30` | no |
| <a name="input_untagged_expiry_days"></a> [untagged\_expiry\_days](#input\_untagged\_expiry\_days) | Days after which untagged images are expired | `number` | `14` | no |
| <a name="input_init_repo"></a> [init\_repo](#input\_init\_repo) | Seed the repository with a default image (requires Docker + AWS CLI) | `bool` | `true` | no |
| <a name="input_default_container"></a> [default\_container](#input\_default\_container) | Source image to seed the repository with | `string` | `"nginx:latest"` | no |
| <a name="input_default_tag"></a> [default\_tag](#input\_default\_tag) | Tag to apply to the seeded image | `string` | `"latest"` | no |
| <a name="input_init_script"></a> [init\_script](#input\_init\_script) | Path to a custom init script | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | ECR repository name |
| <a name="output_arn"></a> [arn](#output\_arn) | ECR repository ARN |
| <a name="output_registry_id"></a> [registry\_id](#output\_registry\_id) | ECR registry ID (AWS account ID) |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | ECR repository URL |
| <a name="output_default_image"></a> [default\_image](#output\_default\_image) | Full URI of the default tagged image |
<!-- END_TF_DOCS -->
