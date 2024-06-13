terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.13.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30.0"

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

provider "helm" {
  kubernetes {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
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

  iam_csi_role_arn = module.irsa.iam_csi_role_arn
}

module "irsa" {
  source = "./modules/IRSA"

  oidc_provider = module.eks.oidc_provider_arn
}

module "acm" {
  source = "./modules/Route"

  domain = var.domain
}

module "load_balancer_controller" {
  source = "./modules/Helm"

  cluster_name = module.eks.cluster_name
  iam_role_arn = module.irsa.irsa_role_arn
  vpc_id = module.vpc.vpc_id
  region = var.region
}

module "secrets_manager" {
  source = "terraform-aws-modules/secrets-manager/aws"
  version = "~> 1.1.2"
  name = "psql-credentials"

  ignore_secret_changes = true
  secret_string = jsonencode({
    username = ""
    password = ""
    dbname   = ""
    port     = 0
  })
}

data "aws_secretsmanager_secret_version" "secrets" {
  depends_on = [ module.secrets_manager ]
  secret_id  = module.secrets_manager.secret_id
}
