variable "name" {
  type        = string
  description = "(optional) specify the container repo name. Default: random name prefix with sudo"
  default     = null
}

variable "default_tag" {
  type        = string
  description = "(optional) Specify the default tag for initializing repo"
  default     = "latest"
}

variable "default_container" {
  type        = string
  description = "(optional) name of the container to initialize the ECR repo with. Default: nginx:latest"
  default     = "nginx:latest"
}

variable "init_script" {
  type        = string
  description = "(optional) Path to custom init script"
  default     = null
}

variable "image_tag_mutability" {
  type        = string
  description = "(optional) Immutable repo. Default IMMUTABLE"
  default     = "IMMUTABLE"
}

variable "init_repo" {
  type        = bool
  description = "(optional) Initialize the repo? Default: True"
  default     = true
}
