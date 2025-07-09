# Security Group for ALB
resource "aws_security_group" "alb" {
  name   = "${var.tenant_name}-alb-sg"
  vpc_id = aws_vpc.tenant.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tenant_name}-alb-sg"
  }
}
resource "aws_lb" "tenant" {
  name               = "${var.tenant_name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.tenant_subnet_1.id, aws_subnet.tenant_subnet_2.id]
  security_groups    = [aws_security_group.alb.id]

  tags = {
    Name = "${var.tenant_name}-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "tenant" {
  name        = "${var.tenant_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.tenant.id
  target_type = "instance"

  health_check {
    path     = "/"
    protocol = "HTTP"
  }

  tags = {
    Name = "${var.tenant_name}-tg"
  }
}

# Attach EC2 to TG
resource "aws_lb_target_group_attachment" "tenant" {
  target_group_arn = aws_lb_target_group.tenant.arn
  target_id        = aws_instance.tenant_app.id
  port             = 80
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.tenant.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.tenant.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tenant.arn
  }
}