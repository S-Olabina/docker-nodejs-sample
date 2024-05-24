variable "owner" {
    type = string
    default = "Stefan Olabina"
}

variable "repository_read_write_access_arns" {
  description = "List of ARNs with read/write access to the ECR repository"
  type        = list(string)
}