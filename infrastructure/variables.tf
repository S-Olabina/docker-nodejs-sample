variable "owner" {
    type = string
    default = "Stefan Olabina"
}

variable "region" {
  description = "AWS region"
  type = string
  default = "eu-central-1"
}

variable "profile" {
    default = "OlabinaS"
    type = string
}

variable "domain" {
  type = string
  default = "stefan-olabina.sigma.devops.sitesstage.com"
}