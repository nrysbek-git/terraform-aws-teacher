data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "web" {
  name_prefix = "${var.name}-web-"
  description = "Allow HTTP traffic to the training web server"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidrs
  }

  egress {
    description = "Required for package installation and updates"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-web-sg" })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data = <<-EOT
    #!/bin/bash
    set -euxo pipefail
    dnf install -y nginx
    cat > /usr/share/nginx/html/index.html <<'HTML'
    <!doctype html>
    <html lang="en">
      <head><meta charset="utf-8"><title>Terraform Foundations</title></head>
      <body style="font-family:system-ui;max-width:760px;margin:80px auto;padding:24px">
        <h1>Infrastructure created with Terraform</h1>
        <p>The VPC, subnet, route, security group and EC2 instance are managed as code.</p>
      </body>
    </html>
    HTML
    systemctl enable --now nginx
  EOT

  tags = merge(var.tags, { Name = "${var.name}-web" })
}

