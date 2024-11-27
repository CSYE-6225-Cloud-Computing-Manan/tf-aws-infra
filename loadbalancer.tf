
resource "aws_security_group" "loadBalancer_sg" {
  name        = "load balancer"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description      = "https from Anywhere for LB"
    from_port        = var.https_port
    to_port          = var.https_port
    protocol         = var.tcp_protocol
    cidr_blocks      = var.ingress_cidr_blocks
    ipv6_cidr_blocks = var.ipv6_cidr_block
  }

  ingress {
    description      = "http from anywhere for LB"
    from_port        = var.http_port
    to_port          = var.http_port
    protocol         = var.tcp_protocol
    cidr_blocks      = var.ingress_cidr_blocks
    ipv6_cidr_blocks = var.ipv6_cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = {
    Name = "load balancer"
  }
}

resource "aws_lb" "lb" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.loadBalancer_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  tags = {
    Application = "WebApp-csye6225"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = var.tg_name
  port        = var.app_port
  protocol    = var.http_protocol
  vpc_id      = aws_vpc.dev_vpc.id
  target_type = var.target_type
  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.http_protocol
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 30
    interval            = 60
  }
}
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.http_port
  protocol          = var.http_protocol
  default_action {
    type             = var.lb_listener_type
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
