variable instance_type {}
variable instance_ami {}

resource "aws_instance" "sentry" {
  ami           = "${var.instance_ami}" 
  instance_type = "${var.instance_type}" 
  subnet_id = "${var.az1_subnet}" 
  security_groups = ["${aws_security_group.sentry.id}"]
  key_name = "sentry"
  tags = {
    Name = "Sentry"
  }
user_data = <<EOF
#!/bin/sh
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user
systemctl enable docker
curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
wget https://github.com/getsentry/self-hosted/archive/refs/tags/22.3.0.tar.gz
tar -xf 22.3.0.tar.gz
cd self-hosted-22.3.0
sed -i '' '224,227 s/^##*//' sentry/sentry.conf.py
./install.sh --skip-user-prompt
docker-compose up -d
EOF
}
