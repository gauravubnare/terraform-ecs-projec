resource "aws_lb" "rolax-alb" {
  name               = "Rolax-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ var.alb_sg ]
  subnets            = [ "${var.subnet01}" , "${var.subnet02}"]
}

resource "aws_lb_target_group" "Rolax-Target-Group" {
  name        = "Rolax-Target-Group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}


resource "aws_lb_listener" "ELB_Listner" {
  load_balancer_arn = aws_lb.rolax-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Rolax-Target-Group.arn
  }
}