module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.12"

  cluster_name    = "task2_eks"
  cluster_version = "1.30"

  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = ["82.117.207.248/32"]

  cluster_endpoint_private_access = true
  
  cluster_addons = {
    aws-ebs-csi-driver = {
      addon_version            = "v1.30.0-eksbuild.1"
      service_account_role_arn = var.iam_csi_role_arn
      resolve_conflicts        = "PRESERVE"
    }
  }

  eks_managed_node_groups = {
    task2_node_group = {
      create_iam_role = true

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }

      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"

      ami_type = "BOTTLEROCKET_x86_64"
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    task2-github-access_entries = {
      principal_arn = var.principal_arn

      policy_associations = {
        task2-eks-policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          access_scope = {
            namespaces = ["vegait-training"]
            type       = "namespace"
          }
        }
      }
    }
  }


  tags = {
    Terraform   = "true"
  }
}