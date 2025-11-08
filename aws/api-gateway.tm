generate_hcl "_auto_generated_api_gateway.tf" {
  content {
    resource "aws_apigatewayv2_api" "api" {
      name          = "api-app"
      protocol_type = "HTTP"
    }

    resource "aws_apigatewayv2_integration" "api_integration" {
      api_id           = aws_apigatewayv2_api.api[0].id
      integration_type = "HTTP_PROXY"
      integration_uri  = "http://${aws_lb.dns_name}/api"
      integration_method = "ANY"
    }

    resource "aws_apigatewayv2_route" "api_route" {
      api_id    = aws_apigatewayv2_api.api[0].id
      route_key = "ANY /{proxy+}"
      target    = "integrations/${aws_apigatewayv2_integration.api_integration[0].id}"
    }

    resource "aws_apigatewayv2_stage" "api_stage" {
      api_id      = aws_apigatewayv2_api.api[0].id
      name        = "$default"
      auto_deploy = true
    }
  }
}
