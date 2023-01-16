resource "aws_lb_target_group" "jenkins" {
  name     = "jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
    health_check {
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "403"
  }
}

resource "aws_lb_target_group_attachment" "jenkins_lb_attach" {
  target_group_arn = aws_lb_target_group.jenkins.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}

resource "aws_lb_target_group" "nexus" {
  name     = "nexus-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}
resource "aws_lb_target_group_attachment" "nexus_lb_attach" {
  target_group_arn = aws_lb_target_group.nexus.arn
  target_id        = aws_instance.nexus.id
  port             = 8081
}

resource "aws_lb_target_group" "tomcat" {
  name     = "tomcat-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}
resource "aws_lb_target_group_attachment" "tomcat_lb_attach" {
  target_group_arn = aws_lb_target_group.tomcat.arn
  target_id        = aws_instance.tomcat_ami_instance.id
  port             = 8080
}
resource "aws_autoscaling_attachment" "alb" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.tomcat.arn
}
