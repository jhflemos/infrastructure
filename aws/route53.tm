generate_hcl "_auto_generated_route53.tf" {
  content {
    locals {
     domain_name = "lemosit.com"
    }

    resource "aws_route53_zone" "main" {
      name = local.domain_name
    }

    resource "aws_acm_certificate" "apps" {
      provider = aws.us_east_1

      domain_name = "app.${local.domain_name}"
      subject_alternative_names = ["*.app.${local.domain_name}"]
      validation_method = "DNS"

      lifecycle {
        create_before_destroy = true
      }
    }

    resource "aws_acm_certificate" "alb_cert" {
      domain_name               = "app.${local.domain_name}"
      subject_alternative_names = ["*.app.${local.domain_name}"]
      validation_method         = "DNS"

      lifecycle {
        create_before_destroy = true
      }
    }

    resource "aws_route53_record" "apps_validation" {
      for_each = {
        for dvo in aws_acm_certificate.apps.domain_validation_options : dvo.domain_name => {
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
      zone_id         = aws_route53_zone.main.zone_id
    }

    resource "aws_route53_record" "alb_cert_validation" {
      allow_overwrite = true

      for_each = {
        for dvo in aws_acm_certificate.alb_cert.domain_validation_options : dvo.domain_name => {
          name   = dvo.resource_record_name
          record = dvo.resource_record_value
          type   = dvo.resource_record_type
        }
      }

      name    = each.value.name
      records = [each.value.record]
      ttl     = 60
      type    = each.value.type
      zone_id = aws_route53_zone.main.zone_id
    }

    resource "aws_acm_certificate_validation" "apps" {
      provider = aws.us_east_1
      
      certificate_arn         = aws_acm_certificate.apps.arn
      validation_record_fqdns = [for record in aws_route53_record.apps_validation : record.fqdn]

      timeouts {
        create = "5m"
      }
    }

    resource "aws_acm_certificate_validation" "alb_cert" {
      certificate_arn         = aws_acm_certificate.alb_cert.arn
      validation_record_fqdns = [for record in aws_route53_record.alb_cert_validation : record.fqdn]
    }

    resource "aws_route53_record" "app_alias" {
      zone_id = aws_route53_zone.main.zone_id
      name    = "app"
      type    = "A"

      alias {
        name                   = aws_cloudfront_distribution.app.domain_name
        zone_id                = aws_cloudfront_distribution.app.hosted_zone_id
        evaluate_target_health = false
      }
    }

    resource "aws_route53_record" "app_alias_ipv6" {
      zone_id = aws_route53_zone.main.zone_id
      name    = "app"
      type    = "AAAA"

      alias {
        name                   = aws_cloudfront_distribution.app.domain_name
        zone_id                = aws_cloudfront_distribution.app.hosted_zone_id
        evaluate_target_health = false
      }
    }


  }
}

