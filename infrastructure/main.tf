terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  profile = var.profile
}

module "vpc" {
  source = "./modules/VPC"
}

module "iam_assumable_role_with_oidc" {
  source = "./modules/IAM"
}

module "ecr"{
  source = "./modules/ECR"

  repository_read_write_access_arns = [module.iam_assumable_role_with_oidc.iam_role_arn]
}

