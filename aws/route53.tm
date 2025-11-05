generate_hcl "_auto_generated_route53.tf" {
  content {
    locals {
     domain_name = "lemosit.com"
    }
    resource "aws_route53_zone" "main" {
      name = local.domain_name
    }

    resource "aws_acm_certificate" "wildcard" {
      domain_name = "*.${local.domain_name}"
      validation_method = "DNS"
    }

    resource "aws_route53_record" "wildcard_validation" {
      name    = aws_acm_certificate.wildcard.domain_validation_options[0].resource_record_name
      type    = aws_acm_certificate.wildcard.domain_validation_options[0].resource_record_type
      zone_id = aws_route53_zone.main.zone_id
      records = [aws_acm_certificate.wildcard.domain_validation_options[0].resource_record_value]
      ttl     = 60
    }

    resource "aws_acm_certificate_validation" "wildcard" {
      certificate_arn         = aws_acm_certificate.wildcard.arn
      validation_record_fqdns = [aws_route53_record.wildcard_validation.fqdn]
    }

    resource "aws_route53_record" "app_alias" {
      zone_id = aws_route53_zone.main.zone_id
      name    = "app.lemosit.com"
      type    = "A"

      alias {
        name                   = aws_lb.app_alb.dns_name
        zone_id                = aws_lb.app_alb.zone_id
        evaluate_target_health = true
      }
    }

  }
}

