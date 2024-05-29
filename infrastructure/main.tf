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
  default_tags {
    tags = {
      Owner = var.owner
    }
  }
}

module "vpc" {
  source = "./modules/VPC"
}

module "iam_assumable_role_with_oidc" {
  source = "./modules/IAM"
}

module "ecr" {
  source = "./modules/ECR"

  repository_read_write_access_arns = [module.iam_assumable_role_with_oidc.iam_role_arn]
}

module "eks"{
  source = "./modules/EKS"

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
  principal_arn = module.iam_assumable_role_with_oidc.iam_role_arn
}