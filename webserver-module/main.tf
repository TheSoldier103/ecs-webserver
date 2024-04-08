# Define the Route 53 hosted zone for your domain
resource "aws_route53_zone" "mydomain_zone" {
  name = var.domain
}

# Create an ALIAS record pointing to your ALB within the hosted zone
resource "aws_route53_record" "alb_record" {
  zone_id = aws_route53_zone.mydomain_zone.zone_id
  name    = "${var.sub-domain}.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_alb.application_load_balancer.dns_name
    zone_id                = aws_alb.application_load_balancer.zone_id
    evaluate_target_health = true
  }
}
