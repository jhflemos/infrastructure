generate_hcl "_auto_generated_route53.tf" {
  condition = tm_anytrue([
     tm_try(global.route53, false), # only render if `route53` is `true`
  ])

  content {
    locals {
     domain_name = "lemosit.com"
    }

    resource "aws_route53_zone" "main" {
      name = local.domain_name
    }

    resource "aws_acm_certificate" "root" {
      domain_name               = local.domain_name
      subject_alternative_names = ["www.${local.domain_name}"]
      validation_method         = "DNS"

      lifecycle {
        create_before_destroy = true
      }
    }

    resource "aws_route53_record" "root_alias" {
      zone_id = aws_route53_zone.main.zone_id
      name    = local.domain_name
      type    = "A"

      alias {
        name                   = aws_lb.app_alb.dns_name
        zone_id                = aws_lb.app_alb.zone_id
        evaluate_target_health = true
      }
    }

    resource "aws_route53_record" "www_alias" {
      zone_id = aws_route53_zone.main.zone_id
      name    = "www"
      type    = "A"

      alias {
        name                   = aws_lb.app_alb.dns_name
        zone_id                = aws_lb.app_alb.zone_id
        evaluate_target_health = true
      }
    }

    resource "aws_route53_record" "root_validation" {
      for_each = {
        for dvo in aws_acm_certificate.root.domain_validation_options : dvo.domain_name => {
          name   = dvo.resource_record_name
          record = dvo.resource_record_value
          type   = dvo.resource_record_type
        }
      }

      allow_overwrite = true
      name    = each.value.name
      records = [each.value.record]
      ttl     = 60
      type    = each.value.type
      zone_id = aws_route53_zone.main.zone_id
    }

    # Wait for certificate validation to complete
    resource "aws_acm_certificate_validation" "root" {
      timeouts {
        create = "5m"
      }

      certificate_arn         = aws_acm_certificate.root.arn
      validation_record_fqdns = [for record in aws_route53_record.root_validation : record.fqdn]
    }

  }
}

