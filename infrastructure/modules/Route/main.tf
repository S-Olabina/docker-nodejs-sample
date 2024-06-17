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

data "kubernetes_ingress_v1" "abl-controller-ingress" {
  metadata {
    name = "${var.ingress-name}-ingress"
    namespace = var.ingress-namespace
  }
}

locals {
  alb-name = split("-", split(".", data.kubernetes_ingress_v1.abl-controller-ingress.status[0].load_balancer[0].ingress[0].hostname).0)
}

data "aws_lb" "aws-alb" {
  name = join("-", slice(local.alb-name, 0, length(local.alb-name) - 1))
}

resource "aws_route53_record" "domain-record" {
  zone_id = data.aws_route53_zone.hosted-zone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = data.aws_lb.aws-alb.dns_name
    zone_id                = data.aws_lb.aws-alb.zone_id
    evaluate_target_health = true
  }
}

