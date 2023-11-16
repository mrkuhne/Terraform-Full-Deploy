resource "aws_vpc" "vpc" {
    cidr_block              = var.vpc_cidr_block
    enable_dns_hostnames    = true

    tags        = {
        Name    = "${var.environment}_vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags        = {
        Name    = "${var.environment}_igw"
    }
}

resource "aws_subnet" "public_subnet" {
  count                     = var.subnet_count.public
  vpc_id                    = aws_vpc.vpc.id
  cidr_block                = var.public_subnet_cidr_blocks[count.index]
  availability_zone         = data.aws_availability_zones.availability_zones.names[count.index]
  map_public_ip_on_launch   = true

    tags                = {
        Name            = "${var.environment}_public_subnet_${count.index}"
    }
}

resource "aws_subnet" "private_subnet" {
    count               = var.subnet_count.private
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = var.private_subnet_cidr_blocks[count.index]
    availability_zone   = data.aws_availability_zones.availability_zones.names[count.index]

    tags                = {
        Name            = "${var.environment}_private_subnet_${count.index}"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id              = aws_vpc.vpc.id
    route {
        cidr_block      = "0.0.0.0/0"
        gateway_id      = aws_internet_gateway.igw.id
    }

     tags               = {
        Name            = "${var.environment}_public_route_table"
    }
}

resource "aws_route_table_association" "public" {
    count               = var.subnet_count.public
    route_table_id      = aws_route_table.public_rt.id
    subnet_id           = aws_subnet.public_subnet[count.index].id 
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vpc.id

        tags           = {
            Name            =  "${var.environment}_private_route_table"
    }
}

resource "aws_route_table_association" "private" {
    count               = var.subnet_count.private
    route_table_id      = aws_route_table.private_rt.id
    subnet_id           = aws_subnet.private_subnet[count.index].id 
}

resource "aws_network_interface" "network_interface" {
    count   = var.subnet_count.public
    subnet_id = aws_subnet.public_subnet[count.index].id
    security_groups = [aws_security_group.instance_security.id]

    tags        = {
        Name    = "${var.environment}_nwi"
    }
}

resource "aws_eip" "web_eip" {
    count       = var.instance_count   
    instance    = aws_instance.instance[count.index].id
    domain      = "vpc"

    tags            = {
        Name        = "${var.environment}_eip" 
    }
}
