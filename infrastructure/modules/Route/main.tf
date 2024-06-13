data "aws_route53_zone" "hosted-zone" {
  name = "sigma.devops.sitesstage.com"
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = var.domain
  zone_id      = data.aws_route53_zone.hosted-zone.zone_id
  validation_method = "DNS"

  wait_for_validation = true

  tags = {
    Name = var.domain
  }
}

