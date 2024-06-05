output "irsa_role_arn" {
  value = module.irsa_for_load_balancer.iam_role_arn
}