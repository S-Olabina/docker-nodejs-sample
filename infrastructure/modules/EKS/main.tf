module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "task2-cluster"
  cluster_version = "1.29"

  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = ["82.117.207.248/32"]

  cluster_endpoint_private_access = true
  
  eks_managed_node_groups = {
    task2-node_group = {
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


  tags = {
    Terraform   = "true"
  }
}