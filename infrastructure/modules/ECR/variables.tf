variable "repository_read_write_access_arns" {
  description = "List of ARNs with read/write access to the ECR repository"
  type        = list(string)
}