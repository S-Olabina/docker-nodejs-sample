module "irsa_for_load_balancer" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "task2-irsa-for-LB"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    one = {
      provider_arn               = var.oidc_provider
      namespace_service_accounts = ["vegait-load-balancer:load-balancer"]
    }
  }
}

module "iam_csi_driver_irsa" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "task2-irsa-csi"

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}