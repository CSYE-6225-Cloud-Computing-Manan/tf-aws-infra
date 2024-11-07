data "aws_route53_zone" "primary" {
  name = var.domain_name
}

# Route 53 A Record
resource "aws_route53_record" "webapp_lb_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = var.record_type_A
  #ttl     = 60

  #records = [local.ec2_public_ip] # Use the local variable for EC2 IP
  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
