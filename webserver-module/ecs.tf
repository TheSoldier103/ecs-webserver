# Resource for creating an ECS cluster
resource "aws_ecs_cluster" "web_cluster" {
  name = "web-cluster"
}

# Resource for creating an ECS task definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "my-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  # Container definition as a single container
  container_definitions = jsonencode([{
    name   = "public-web-container"
    image  = "${aws_ecr_repository.public_web_server.repository_url}:latest"
    cpu    = 256
    memory = 512
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

# Resource for creating an ECS service
resource "aws_ecs_service" "service" {
  name            = "public-web-service"
  cluster         = aws_ecs_cluster.web_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  # Network configuration for the ECS service
  network_configuration {
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_sg.id, aws_security_group.alb_sg.id]
  }

  # Load balancer configuration
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "public-web-container"
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.listener]
}

# IAM role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM role policy attachment for ECS task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
