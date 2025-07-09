
resource "aws_security_group" "ec2" {
  name   = "${var.tenant_name}-ec2-sg"
  vpc_id = aws_vpc.tenant.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups  = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# AMI for RHEL DevOps image
data "aws_ami" "rhel9_devops" {
  owners      = ["973714476881"]
  most_recent = true
  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }
}

# EC2 Instance
resource "aws_instance" "tenant_app" {
  ami                    = data.aws_ami.rhel9_devops.id
  instance_type          = var.instance_type
  subnet_id = aws_subnet.tenant_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  user_data              = <<-EOF
    #!/bin/bash
    sudo dnf install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
    echo "Welcome to ${var.tenant_name}" > /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name = "tenant-app-${var.tenant_name}"
  }
}
