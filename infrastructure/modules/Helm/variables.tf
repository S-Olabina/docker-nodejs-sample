variable "cluster_name" {
	type = string
}

variable "iam_role_arn" {
	type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type = string
}