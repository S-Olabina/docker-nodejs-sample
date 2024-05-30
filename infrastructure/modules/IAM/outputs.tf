output "iam_role_arn" {
  value = module.iam_assumable_role_with_oidc.iam_role_arn
}

output "oidc_provider" {
  value = module.iam_assumable_role_with_oidc.provider_arn
}