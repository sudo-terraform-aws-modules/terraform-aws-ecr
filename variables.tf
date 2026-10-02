variable "name" {
  type        = string
  description = "(optional) ECR repository name. Default: randomly generated"
  default     = null
}

variable "image_tag_mutability" {
  type        = string
  description = "(optional) Tag mutability. IMMUTABLE prevents tags from being overwritten. Default: IMMUTABLE"
  default     = "IMMUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  type        = bool
  description = "(optional) Enable image vulnerability scanning on push. Default: true"
  default     = true
}

variable "encryption_type" {
  type        = string
  description = "(optional) Encryption type for the repository. AES256 uses AWS-managed keys, KMS uses a customer-managed key. Default: AES256"
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be AES256 or KMS."
  }
}

variable "kms_key" {
  type        = string
  description = "(optional) ARN of the KMS key to use when encryption_type is KMS. If not set, the default AWS-managed ECR key is used"
  default     = null
}

variable "repository_policy" {
  type        = string
  description = "(optional) JSON repository policy for cross-account or cross-service access. Default: null (no policy)"
  default     = null
}

variable "keep_count" {
  type        = number
  description = "(optional) Number of tagged images to keep per tag prefix. Default: 30"
  default     = 30
}

variable "untagged_expiry_days" {
  type        = number
  description = "(optional) Number of days after which untagged images are expired. Default: 14"
  default     = 14
}

variable "init_repo" {
  type        = bool
  description = "(optional) Seed the repository with a default image on creation. Requires Docker and AWS CLI on the machine running Terraform. Default: true"
  default     = true
}

variable "default_container" {
  type        = string
  description = "(optional) Source container image to seed the repository with. Default: nginx:latest"
  default     = "nginx:latest"
}

variable "default_tag" {
  type        = string
  description = "(optional) Tag to apply to the seeded image. Default: latest"
  default     = "latest"
}

variable "init_script" {
  type        = string
  description = "(optional) Path to a custom init script. Default: built-in scripts/init-ecr-repo.sh"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "(optional) Tags to apply to all resources"
  default     = {}
}
