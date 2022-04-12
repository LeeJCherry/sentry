

resource "aws_security_group" "sentry" {
  name        = "sentry"
  description = "Security Group for Sentry Instance"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description      = "External Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # ANY rule used as the service is short lived and does not contain sensitive data
    ipv6_cidr_blocks = ["::/0"] # ANY rule used as the service is short lived and does not contain sensitive data
  }

    ingress {
    from_port = 9000
    to_port   = 9000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ANY rule used as the service is short lived and does not contain sensitive data
    ipv6_cidr_blocks = ["::/0"] # ANY rule used as the service is short lived and does not contain sensitive data
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"] # ANY rule used as egress hardening is out of scope
    ipv6_cidr_blocks = ["::/0"] # ANY rule used as egress hardening is out of scope
  }

  tags = {
    Name = "sentry"
  }
}

output "sg_id" {
  value = "${aws_security_group.sentry.id}"
}