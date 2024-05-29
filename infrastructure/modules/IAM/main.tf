module "iam_assumable_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role = true

  role_name = "github-actions-ecr-role"

  tags = {
    Role = "github-actions-ecr-role"
  }

  provider_url = module.iam_github_oidc_provider.url

  role_policy_arns = [
    module.iam_policy.arn,
  ]
  number_of_role_policy_arns = 1

  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
  //oidc_fully_qualified_subject = ["repo:s-olabina/docker-nodejs-sample:ref:refs/heads:main"]
  oidc_subjects_with_wildcards = [var.wildcard]
}


module "iam_github_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "github-actions-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:UploadLayerPart",
        "ecr:BatchDeleteImage"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "eks:AccessKubernetesApi",
        "eks:DescribeNodegroup",
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:ListNodegroups",
        "sts:AssumeRoleWithWebIdentity"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}