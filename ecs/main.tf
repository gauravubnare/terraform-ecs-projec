resource "aws_ecs_task_definition" "Rolax_Task_Defination" {
  family = "Rolax_Task_Defination"
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.ECS_Role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 1024

  container_definitions = jsonencode([
    {
      name      = "Rolax-Web"
      image     = "${var.ecs_image_id}"
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 80
        }
      ]
    },
  ])
depends_on = [ aws_iam_role_policy.ECS_Policy]
}

resource "aws_ecs_cluster" "Rolax_Cluster" {
  name = "Rolax_Cluster"
}

resource "aws_iam_role" "ECS_Role" {
  name = "ECS_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ECS_Policy" {
  name = "ECS_Policy"
  role = aws_iam_role.ECS_Role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_ecs_service" "rolax-web-service" {
  name            = "rolax-web-service"
  cluster         = aws_ecs_cluster.Rolax_Cluster.id
  task_definition = aws_ecs_task_definition.Rolax_Task_Defination.arn
  desired_count   = 2
  launch_type = "FARGATE"

  network_configuration {
    security_groups = ["${var.ecs_sg}"]
    subnets = ["${var.subnet01}","${var.subnet02}"]
    assign_public_ip = true
  }
 
  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = "Rolax-Web"
    container_port   = 80
  }
}