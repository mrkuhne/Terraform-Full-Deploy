data "aws_subnets" "existing_subnets" {
    filter {
        name    = "vpc-id"
        values  = [var.vpc_id]
    }
}

resource "aws_network_interface" "network_interface" {
  subnet_id       = tolist(data.aws_subnets.existing_subnets.ids)[1]
  security_groups = [aws_security_group.prometheus_security.id]

  tags = {
    Name = "${var.environment}_prometheus_nwi"
  }
}

resource "aws_instance" "instance_prometheus" {
    ami                     = var.ami
    instance_type           = var.instance_type
    key_name                = "daniels-key-to-my-heart" 

    network_interface {
      network_interface_id  = aws_network_interface.network_interface.id
      device_index          = 0
    }

    tags     = {
        Name = "${var.environment}_prometheus"
  }

  user_data = file("../prometheus-modules/prometheus-config.sh")
}
