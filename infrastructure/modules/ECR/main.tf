module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "private-ecr-repo"

  repository_read_write_access_arns = var.repository_read_write_access_arns

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
  }
}

data "aws_ecr_authorization_token" "login-token" {
  
}