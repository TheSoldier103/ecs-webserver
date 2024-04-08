# Resource for creating an ECR repository
resource "aws_ecr_repository" "public_web_server" {
  name         = "public_web_repo"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Resource using the null provider to handle Docker packaging and pushing to ECR
resource "null_resource" "docker_packaging" {
  # Local-exec provisioner to login, build, tag, and push Docker image
  provisioner "local-exec" {
    command = <<-EOF
      aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${var.aws_account}.dkr.ecr.us-east-1.amazonaws.com
      docker build -t public_web_server .
      docker tag public_web_server:latest ${aws_ecr_repository.public_web_server.repository_url}:latest
      docker push ${aws_ecr_repository.public_web_server.repository_url}:latest
    EOF
  }

  # Triggers to ensure this runs every apply
  triggers = {
    "run_at" = timestamp()
  }

  depends_on = [
    aws_ecr_repository.public_web_server,
  ]
}
