data "aws_lb" "selected" {
  arn = var.alb_arn
}

# Enable private link for shoplytics-api-preivew
resource "aws_lb" "this" {
  name               = "nlb-${var.service_name}"
  internal           = true
  load_balancer_type = "network"
  subnets            = [for subnet in data.aws_lb.selected.subnet_mapping : subnet.subnet_id]

  tags = var.nlb_tags
}

resource "aws_lb_target_group" "this" {
  name        = "tg-alb-${var.service_name}"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = data.aws_lb.selected.vpc_id

  health_check {
    interval            = 30
    protocol            = "HTTP"
    path                = "/health_check"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
  }  
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.alb_arn
  port             = 80
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_vpc_endpoint_service" "this" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.this.arn]
  tags = var.endpoint_service_tags
}

resource "aws_vpc_endpoint_service_allowed_principal" "this" {
  vpc_endpoint_service_id = aws_vpc_endpoint_service.this.id
  principal_arn           = var.principal_arn
}
