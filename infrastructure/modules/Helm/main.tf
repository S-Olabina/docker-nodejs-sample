module load-balancer-controller {
  source  = "terraform-module/release/helm"
  version = "~> 2.8.0"

  namespace  = "vegait-training"
  repository =  "https://aws.github.io/eks-charts"

  app = {
    name          = "aws-load-balancer-controller"
    version       = "1.8.1"
    chart         = "aws-load-balancer-controller"
    deploy        = 1
  }


  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = var.iam_role_arn
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
  ]
}