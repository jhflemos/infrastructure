generate_hcl "_auto_generated_ecs.tf" {
  content {
    resource "aws_ecs_cluster" "ecs_cluster" {
      name = "${global.environment}-ecs-cluster"

      tags = { 
        Name = "${global.environment}-ecs-cluster" 
      }
    }
  }
}
