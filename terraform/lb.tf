resource "aws_lb" "test" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.lb.id]
  subnets = local.public_subnet_ids
  enable_deletion_protection = false
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "8095"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 8095
  protocol = "UDP"
  vpc_id   = local.vpc_id
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.web.id
  port             = 8095
}

resource "aws_security_group" "lb" {
  vpc_id = local.vpc_id

  ingress {
    from_port   = 8095
    to_port     = 8095
    protocol    = "UDP"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

