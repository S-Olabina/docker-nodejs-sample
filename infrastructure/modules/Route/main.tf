data "aws_route53_zone" "hosted-zone" {
  name = "sigma.devops.sitesstage.com"
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = "stefan-olabina.sigma.devops.sitesstage.com"
  zone_id      = data.aws_route53_zone.hosted-zone.zone_id
  validation_method = "DNS"

  wait_for_validation = true

  tags = {
    Name = "stefan-olabina.sigma.devops.sitesstage.com"
  }
}

