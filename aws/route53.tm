generate_hcl "_auto_generated_route53.tf" {
  content {
    locals {
     domain_name = "lemosit.com"
    }

    resource "aws_route53_zone" "main" {
      count = global.route53 ? 1 : 0

      name = local.domain_name
    }

    resource "aws_acm_certificate" "root" {
      count = global.route53 ? 1 : 0
      
      domain_name               = local.domain_name
      subject_alternative_names = ["www.${local.domain_name}"]
      validation_method         = "DNS"

      lifecycle {
        create_before_destroy = true
      }
    }

    resource "aws_route53_record" "root_alias" {
      count = global.route53 ? 1 : 0
      
      zone_id = aws_route53_zone.main[0].zone_id
      name    = local.domain_name
      type    = "A"

      alias {
        name                   = aws_lb.app_alb.dns_name
        zone_id                = aws_lb.app_alb.zone_id
        evaluate_target_health = true
      }
    }

    resource "aws_route53_record" "www_alias" {
      count = global.route53 ? 1 : 0
      
      zone_id = aws_route53_zone.main[0].zone_id
      name    = "www"
      type    = "A"

      alias {
        name                   = aws_lb.app_alb.dns_name
        zone_id                = aws_lb.app_alb.zone_id
        evaluate_target_health = true
      }
    }

    resource "aws_route53_record" "root_validation" {
      for_each = global.route53 ? {
        for dvo in aws_acm_certificate.root[0].domain_validation_options : dvo.domain_name => {
          name   = dvo.resource_record_name
          record = dvo.resource_record_value
          type   = dvo.resource_record_type
        }
      } : {}

      allow_overwrite = true
      name    = each.value.name
      records = [each.value.record]
      ttl     = 60
      type    = each.value.type
      zone_id = aws_route53_zone.main[0].zone_id
    }

    # Wait for certificate validation to complete
    resource "aws_acm_certificate_validation" "root" {
      count = global.route53 ? 1 : 0
      
      timeouts {
        create = "5m"
      }

      certificate_arn         = aws_acm_certificate.root[0].arn
      validation_record_fqdns = [for record in aws_route53_record.root_validation[0] : record.fqdn]
    }

  }
}
