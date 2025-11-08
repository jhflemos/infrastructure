generate_hcl "_auto_generated_api_gateway.tf" {
  content {
    resource "aws_apigatewayv2_api" "api" {
      name          = "api-app"
      protocol_type = "HTTP"
    }

    resource "aws_apigatewayv2_integration" "api_integration" {
      api_id           = aws_apigatewayv2_api.api.id
      integration_type = "HTTP_PROXY"
      integration_uri  = "http://${aws_lb.app_alb.dns_name}/api"
      integration_method = "ANY"
    }

    resource "aws_apigatewayv2_route" "api_route" {
      api_id    = aws_apigatewayv2_api.api.id
      route_key = "ANY /{proxy+}"
      target    = "integrations/${aws_apigatewayv2_integration.api_integration.id}"
    }

    resource "aws_apigatewayv2_stage" "api_stage" {
      api_id      = aws_apigatewayv2_api.api.id
      name        = "$default"
      auto_deploy = true
    }
  }
}
