generate_hcl "_auto_generated_security_group.tf" {
  content {
    resource "aws_security_group" "alb_sg" {
      name        = "${global.environment}-alb-sg"
      description = "Allow HTTP and HTTPS"
      vpc_id      = module.vpc.vpc_id

      ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }

      tags = {
        Name = "${global.environment}-alb-sg"
      }
    }
  }
}
