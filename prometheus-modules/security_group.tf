resource "aws_security_group" "prometheus_security" {
    name        = "prometheus-security-group"
    vpc_id      = var.vpc_id

    tags        = {
        Name    = "${var.environment}_prometheus_sg"
    }
}

resource "aws_security_group_rule" "allow_http_inbound_3000" {           
    type                = "ingress"
    security_group_id   = aws_security_group.prometheus_security.id

    from_port           = 3000
    to_port             = 3000
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_inbound_9090" {           
    type                = "ingress"
    security_group_id   = aws_security_group.prometheus_security.id

    from_port           = 9090
    to_port             = 9090
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_inbound_9100" {           
    type                = "ingress"
    security_group_id   = aws_security_group.prometheus_security.id

    from_port           = 9100
    to_port             = 9100
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_inbound_9104" {           
    type                = "ingress"
    security_group_id   = aws_security_group.prometheus_security.id

    from_port           = 9104
    to_port             = 9104
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_inbound_80" {           
    type                = "ingress"
    security_group_id   = aws_security_group.prometheus_security.id
    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
    type                 = "ingress"
    security_group_id    = aws_security_group.prometheus_security.id

    from_port            = 22
    to_port              = 22
    protocol             = "tcp"
    cidr_blocks          = ["0.0.0.0/0"] 
}

resource "aws_security_group_rule" "allow_all_outbound" {
    type                = "egress"
    security_group_id   = aws_security_group.prometheus_security.id
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
}
