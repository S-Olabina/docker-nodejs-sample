output "irsa_role_arn" {
  value = module.irsa_for_load_balancer.iam_role_arn
}

output "iam_csi_role_arn" {
  value = module.iam_csi_driver_irsa.iam_role_arn
}