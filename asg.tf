resource "aws_ami_from_instance" "aws_ami_from_instance" {
  depends_on              = [null_resource.tomcat]
  name                    = "AMI for Tomcat server"
  source_instance_id      = aws_instance.tomcat_ami_instance.id
  snapshot_without_reboot = true

  tags = {
    Name = "tomcat-ami"
  }
}


resource "aws_launch_configuration" "tomcat_lc" {
  name_prefix     = "terraform-lc"
  image_id        = aws_ami_from_instance.aws_ami_from_instance.id
  instance_type   = "t3.medium"
  key_name        = var.key_name
  security_groups = [aws_security_group.ec2_sg.id]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "tomcat-asg"
  launch_configuration = aws_launch_configuration.tomcat_lc.name
  min_size             = 1
  max_size             = 3
  vpc_zone_identifier  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "tomcat-asg"
    propagate_at_launch = true
  }
}
