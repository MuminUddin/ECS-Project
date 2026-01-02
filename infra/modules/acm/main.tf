data "aws_route53_zone" "route53_muminlabs" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "A_record_muminlabs" {
  zone_id = data.aws_route53_zone.route53_muminlabs.id
  name    = var.subdomain
  type    = "A"

  alias {
    name                   = var.alb_dns
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "CNAME_muminlabs" {
  for_each = {
    for dvo in aws_acm_certificate.gatus_acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_muminlabs.id
}

# ACM certificate
resource "aws_acm_certificate" "gatus_acm_certificate" {
  domain_name       = local.fqdn
  validation_method = "DNS"

  tags = merge(var.common_tags, {
    Name = "gatus-acm-cert"
  })
}

resource "aws_acm_certificate_validation" "acm_validation" {
  certificate_arn         = aws_acm_certificate.gatus_acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.CNAME_muminlabs : record.fqdn]
}