resource "aws_lb_listener" "http" {
    load_balancer_arn   = aws_lb.load_balancer.arn
    port                = 80
    protocol            = "HTTP"

    default_action {
      type              = "fixed-response"

      fixed_response {
        content_type    = "text/plain"
        message_body    = "404: page not found"
        status_code     = 404  
      }
    }      

    tags        = {
        Name    = "${var.environment}_lb_listener_80"
    } 
}

resource "aws_lb_target_group" "instance_lb" {
    name                    = "${var.environment}-target-group-lb-8080"
    port                    = 8080
    protocol                = "HTTP"
    vpc_id                  = aws_vpc.vpc.id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 15
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2
  }

  tags                      = {
    Name                    = "${var.environment}_lb_target_group"
  }
}

resource "aws_lb_target_group_attachment" "instance_attachment" {
    count               = var.instance_count
    target_group_arn    = aws_lb_target_group.instance_lb.arn
    target_id           = aws_instance.instance[count.index].id
    port                = 8080
}

resource "aws_lb_listener_rule" "instances" {
  listener_arn  = aws_lb_listener.http.arn
  priority      = 100

  condition {
    path_pattern {
      values    = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance_lb.arn
  }

    tags        = {
        Name    = "${var.environment}_forward_all_rule"
    } 
}

resource "aws_lb" "load_balancer" {
    name                  = "${var.environment}-web-lb"
    load_balancer_type    = "application"
    subnets               = [for subnet in aws_subnet.public_subnet : subnet.id]
    security_groups       = [aws_security_group.alb.id] 

    tags                    = {
        Name                = "${var.environment}_load_balancer"
        Environment         = "${var.environment}"
    }
}