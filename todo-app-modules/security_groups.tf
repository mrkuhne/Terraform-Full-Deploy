resource "aws_security_group" "instance_security" {
    name        = "instance-security-group"
    vpc_id      = aws_vpc.vpc.id

    tags        = {
        Name    = "${var.environment}_instance_sg"
    }
}

resource "aws_security_group_rule" "allow_http_inbound" {           
    type                = "ingress"
    security_group_id   = aws_security_group.instance_security.id

    from_port           = 8080
    to_port             = 8080
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_inbound_9100" {           
    type                = "ingress"
    security_group_id   = aws_security_group.instance_security.id

    from_port           = 9100
    to_port             = 9100
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_inbound_80" {           
    type                = "ingress"
    security_group_id   = aws_security_group.instance_security.id

    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
    type                 = "ingress"
    security_group_id    = aws_security_group.instance_security.id

    from_port            = 22
    to_port              = 22
    protocol             = "tcp"
    cidr_blocks          = ["0.0.0.0/0"] 
}

resource "aws_security_group_rule" "allow_all_outbound" {
    type                = "egress"
    security_group_id   = aws_security_group.instance_security.id
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group" "db_security" {
    name                = "${var.environment}_database_security"
    description         = "Security group for the ${var.environment} database"
    vpc_id              = aws_vpc.vpc.id

    ingress {
        description                 = "Allow MySQL traffic from only the web sg"
        from_port                   = 3306
        to_port                     = 3306
        protocol                    = "tcp"
        security_groups             = [aws_security_group.instance_security.id]
    }

    ingress {
        description                 = "Allow logging traffic from only the web sg"
        from_port                   = 9104
        to_port                     = 9104
        protocol                    = "tcp"
        security_groups             = [aws_security_group.instance_security.id]
    }

    tags                            = {
        Name                        = "${var.environment}_db_sg"
    }
}

resource "aws_db_subnet_group" "db_subnet_group" {
    name            = "${var.environment}_db_subnet_group"
    description     = "DB subnet group for ${var.environment}"
    subnet_ids      = [for subnet in aws_subnet.private_subnet : subnet.id]

        tags        = {
            Name    = "${var.environment}_db_subnet_group"
    }
}

resource "aws_security_group" "alb" {
    name        = "alb-security-group"
    vpc_id      = aws_vpc.vpc.id

    tags        = {
        Name    = "${var.environment}_alb_sg"
    }
}

resource "aws_security_group_rule" "allow_alb_http_inbound" {
    type                = "ingress"
    security_group_id   = aws_security_group.alb.id 
    
    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_alb_all_outbound" {
    type                = "egress"
    security_group_id   = aws_security_group.alb.id

    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"] 
}
