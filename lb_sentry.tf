#Cloudfront and WAF have been ommitted to deliver against the requirement.
variable az1_subnet {}
variable az2_subnet {}
variable sentry_cert_arn {}
variable vpc_id {}

resource "aws_alb" "sentry_alb" {
	name		=	"sentry"
	internal	=	false
	security_groups	=	["${aws_security_group.sentry.id}"]
	subnets		=	["${var.az1_subnet}", "${var.az2_subnet}"]
	enable_deletion_protection	=	true
}

resource "aws_alb_target_group" "sentry_https" {
	name	= "sentry-https"
	vpc_id	= "${var.vpc_id}" 
	port	= "443"
	protocol	= "HTTPS"
	health_check {
                path = "/_health/"
                port = "9000"
                protocol = "HTTP"
                healthy_threshold = 2
                unhealthy_threshold = 2
                interval = 5
                timeout = 4
                matcher = "200-308"
        }
}

resource "aws_alb_target_group_attachment" "sentry_backend_http" {
  target_group_arn = "${aws_alb_target_group.sentry_https.arn}"
  target_id        = "${aws_instance.sentry.id}"
  port             = 9000
}

resource "aws_alb_listener" "sentry_https_listener" {
	load_balancer_arn	=	"${aws_alb.sentry_alb.arn}"
	port			=	"443"
	protocol		=	"HTTPS"
	ssl_policy		=	"ELBSecurityPolicy-2016-08"
	certificate_arn		=	"${var.sentry_cert_arn}"

	default_action {
		target_group_arn	=	"${aws_alb_target_group.sentry_https.arn}"
		type			=	"forward"
	}
}