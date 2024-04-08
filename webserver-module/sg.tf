# Define a security group for the ECS application with inbound and outbound rules.
resource "aws_security_group" "ecs_sg" {
  vpc_id                 = aws_vpc.vpc.id
  name                   = "demo-sg-ecs"
  description            = "Security group for ECS application"
  revoke_rules_on_delete = true
}

# Define an ingress rule for allowing traffic from the Application Load Balancer (ALB) to the ECS security group.
resource "aws_security_group_rule" "ecs_alb_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  description              = "Allow inbound traffic from ALB"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}

# Define an egress rule for allowing all outbound traffic from the ECS security group to any destination.
resource "aws_security_group_rule" "ecs_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from ECS"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Define a security group for the Application Load Balancer (ALB) with inbound and outbound rules.
resource "aws_security_group" "alb_sg" {
  vpc_id                 = aws_vpc.vpc.id
  name                   = "demo-sg-alb"
  description            = "Security group for ALB"
  revoke_rules_on_delete = true
}

# Define an ingress rule for allowing HTTP traffic from the internet to the ALB security group.
resource "aws_security_group_rule" "alb_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  description       = "Allow HTTP inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Define an ingress rule for allowing HTTPS traffic from the internet to the ALB security group.
resource "aws_security_group_rule" "alb_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  description       = "Allow HTTPS inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Define an egress rule for allowing all outbound traffic from the ALB security group to any destination.
resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from ALB"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
