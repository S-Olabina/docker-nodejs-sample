output "repository_registry_id" {
  value = module.ecr.repository_registry_id
}
output "repository_url" {
  value = module.ecr.repository_url
}
output "token-username" {
  value = data.aws_ecr_authorization_token.login-token.user_name
}
output "token-password" {
  value = data.aws_ecr_authorization_token.login-token.password
}