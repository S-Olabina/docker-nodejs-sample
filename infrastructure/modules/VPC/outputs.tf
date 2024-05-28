output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = concat(module.vpc.private_subnets)
}