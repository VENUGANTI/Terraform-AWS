data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_instance" "nexus" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet_2.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "nexus-server"
  }

}

resource "aws_instance" "tomcat_ami_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet_3.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt-get install openjdk-8-jdk -y
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /tmp
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.70/bin/apache-tomcat-9.0.70.tar.gz
sudo mkdir /opt/tomcat
cd /opt/tomcat
sudo tar xzvf /tmp/apache-tomcat-9.0.70.tar.gz -C /opt/tomcat --strip-components=1
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/
sudo systemctl daemon-reload
sudo cd /opt/tomcat
sudo bin/startup.sh run
EOF

  tags = {
    Name = "tomcat-ami-server"
  }
}
