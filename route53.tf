data "aws_route53_zone" "primary" {
  name = "${var.subdomain}.${var.domain_name}"
}

# Route 53 A Record
resource "aws_route53_record" "webapp_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "A"
  ttl     = 60

  records = [local.ec2_public_ip] # Use the local variable for EC2 IP
}

# Optional output for the application URL
output "application_url" {
  value       = "http://${aws_route53_record.webapp_record.name}:${var.app_port}/"
  description = "URL to access the application on EC2 instance"
}
