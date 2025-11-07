generate_hcl "_auto_generated_route53.tf" {
  content {
    locals {
     domain_name = "lemosit.com"
    }

    resource "aws_route53_zone" "main" {
      name = local.domain_name

      lifecycle {
        prevent_destroy = true
      }
    }

    resource "aws_acm_certificate" "apps" {
      domain_name = "app.${local.domain_name}"
      subject_alternative_names = ["*.app.${local.domain_name}"]
      validation_method = "DNS"

      lifecycle {
        prevent_destroy = true
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

      lifecycle {
        prevent_destroy = true
      }
    }

    resource "aws_acm_certificate_validation" "apps" {
      timeouts {
        create = "5m"
      }
      certificate_arn         = aws_acm_certificate.apps.arn
      validation_record_fqdns = [for record in aws_route53_record.apps_validation : record.fqdn]

      lifecycle {
        prevent_destroy = true
      }
    }

    resource "aws_route53_record" "app_alias" {
      zone_id = aws_route53_zone.main.zone_id
      name    = "app"
      type    = "A"

      alias {
        name                   = aws_lb.app_alb.dns_name
        zone_id                = aws_lb.app_alb.zone_id
        evaluate_target_health = true
      }

      lifecycle {
        prevent_destroy = true
      }
    }

  }
}

