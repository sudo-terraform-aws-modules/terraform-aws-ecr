locals {
  repo_name   = var.name == null ? "sudo-ci-${random_string.random_name[0].result}" : var.name
  init_script = var.init_script == null ? "${path.module}/scripts/init-ecr-repo.sh" : var.init_script
}

resource "random_string" "random_name" {
  count   = var.name == null ? 1 : 0
  length  = 8
  special = false
  upper   = false
}
