// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "aws_security_group" "alb_sg" {
  description = "Allow HTTP and HTTPS"
  name        = "prod-alb-sg"
  tags = {
    Name = "prod-alb-sg"
  }
  vpc_id = module.vpc.vpc_id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    description = "HTTP"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    description = "HTTPS"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
}
resource "aws_security_group" "ecs_sg" {
  description = "Allow traffic from ALB"
  name        = "prod-ecs-sg"
  tags = {
    Name = "prod-ecs-sg"
  }
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = 3000
    protocol  = "tcp"
    security_groups = [
      aws_security_group.alb_sg.id,
    ]
    to_port = 3000
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
}
