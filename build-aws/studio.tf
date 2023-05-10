## ssh key for servers

resource "aws_key_pair" "ssh_key" {
  key_name   = var.studio_code
  public_key = tls_private_key.ssh_key.public_key_openssh
}

## site vpc

resource "aws_vpc" "site" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = false
  tags = {
    Name = var.studio_code
  }
}

## tag default route table and security group
##   ... and neuter the default security group

resource "aws_default_route_table" "site" {
  default_route_table_id = aws_vpc.site.default_route_table_id
  tags = {
    Name = "${var.studio_code}-default"
  }
}

resource "aws_default_security_group" "site" {
  vpc_id = aws_vpc.site.id
  tags = {
    Name = "${var.studio_code}-default"
  }
}

## public subnet

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.site.id
  tags = {
    Name = "${var.studio_code}-pub"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.site.id
  cidr_block = var.subnet_cidr_blocks.public
  availability_zone = local.aws_availability_zone

  tags = {
    Name = "${var.studio_code}-pub"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.site.id
  tags = {
    Name = "${var.studio_code}-pub"
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.public.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_security_group" "public" {
  vpc_id = aws_vpc.site.id
  tags = {
    Name = "${var.studio_code}-pub"
  }
}

resource "aws_security_group_rule" "public_all_out" {
  security_group_id = aws_security_group.public.id
  type        = "egress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "public_ssh" {
  security_group_id = aws_security_group.public.id
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = [ local.management_net ]
}

resource "aws_security_group_rule" "public_private" {
  security_group_id = aws_security_group.public.id
  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = [ var.subnet_cidr_blocks.private ]
}

## private subnet

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.site.id
  cidr_block = var.subnet_cidr_blocks.private
  availability_zone = local.aws_availability_zone

  tags = {
    Name = "${var.studio_code}-prv"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.site.id
  tags = {
    Name = "${var.studio_code}-prv"
  }
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}

resource "aws_route" "private_default" {
  route_table_id         = aws_route_table.private.id
  network_interface_id   = aws_instance.gateway.primary_network_interface_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_security_group" "private" {
  vpc_id = aws_vpc.site.id
  tags = {
    Name = "${var.studio_code}-prv"
  }
}

resource "aws_security_group_rule" "private_all_out" {
  security_group_id = aws_security_group.private.id
  type        = "egress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "private_public" {
  security_group_id = aws_security_group.private.id
  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  cidr_blocks = [ var.subnet_cidr_blocks.public ]
}

resource "aws_security_group_rule" "private_self" {
  security_group_id = aws_security_group.private.id
  type        = "ingress"
  protocol    = -1
  from_port   = 0
  to_port     = 0
  self        = true
}

