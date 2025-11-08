generate_hcl "_auto_generated_cloudfront.tf" {
  content {
    
    resource "aws_cloudfront_distribution" "app" {
      enabled = true

      origin {
        domain_name = aws_apigatewayv2_api.api.api_endpoint
        origin_id   = "api-gateway-origin"

        custom_origin_config {
          http_port              = 80
          https_port             = 443
          origin_protocol_policy = "https-only"
          origin_ssl_protocols   = ["TLSv1.2"]
        }
      }

      origin {
        domain_name = aws_lb.app_alb.dns_name
        origin_id   = "alb-origin"

        custom_origin_config {
          http_port              = 80
          https_port             = 443
          origin_protocol_policy = "https-only"
          origin_ssl_protocols   = ["TLSv1.2"]
        }
      }

      default_cache_behavior {
        target_origin_id       = "alb-origin"
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods        = ["GET","HEAD","OPTIONS","PUT","POST","PATCH","DELETE"]
        cached_methods         = ["GET","HEAD"]
        forwarded_values {
          query_string = true
          headers      = ["*"]
        }
      }

      ordered_cache_behavior {
        path_pattern           = "/api/*"
        target_origin_id       = "api-gateway-origin"
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods        = ["GET","HEAD","OPTIONS","PUT","POST","PATCH","DELETE"]
        cached_methods         = ["GET","HEAD"]
        forwarded_values {
          query_string = true
          headers      = ["*"]
        }
      }

      viewer_certificate {
        acm_certificate_arn = var.acm_certificate_arn
        ssl_support_method  = "sni-only"
      }

      restrictions {
        geo_restriction {
          restriction_type = "none"
        }
      }

      default_root_object = ""
    }

  }
}

