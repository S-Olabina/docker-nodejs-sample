module load-balancer-controller {
  source  = "terraform-module/release/helm"
  version = "~> 2.8.0"

  namespace  = "vegait-load-balancer"
  repository =  "https://aws.github.io/eks-charts"


  app = {
    name          = "load-balancer"
    version       = "1.8.1"
    chart         = "aws-load-balancer-controller"
    deploy        = 1
    create_namespace = true
  }


  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "serviceAccount.name"
      value = "load-balancer"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = var.iam_role_arn
    },
    {
      name  = "region"
      value = var.region
    },
    {
      name  = "vpcId"
      value = var.vpc_id
    },
    {
      name = "defaultTargetType"
      value = "ip"
    },
  ]
}

resource "helm_release" "psql_bitnami" {
  name = "psql-bitnami"
  repository = "oci://registry-1.docker.io/bitnamicharts/postgresql"
  chart = "psql-bitnami"
  namespace = "vegait-training"
  version = "~> 15.5.0"

  set {
    name = "primary.persistence.enabled"
    value = "true"
  }
  set {
    name = "primary.persistence.storageClass"
    value = "standard"
  }
  set {
    name = "primary.persistence.accessModes[0]"
    value = "ReadWriteOnce"
  }

}