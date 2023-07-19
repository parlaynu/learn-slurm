## the server names and addresses

locals {
  gateway = { 
    "name" : "gateway"
    "public_ip" : aws_instance.gateway.public_ip
    "private_ip" : aws_instance.gateway.private_ip
  }
    
  slurm_controller = { 
    "name" : "slurmctl"
    "private_ip" : aws_instance.controller.private_ip 
  }
  
  slurm_database = {
    "name" : "slurmdb"
    "private_ip" : aws_instance.database.private_ip 
  }

  slurm_workers = {
    for i in range(var.num_workers): format("slurm-%02d", i) => aws_instance.workers[i].private_ip
  }
  
  all_servers = merge(local.slurm_workers, {
    "${local.gateway.name}" : local.gateway.private_ip,
    "${local.slurm_controller.name}" : local.slurm_controller.private_ip,
    "${local.slurm_database.name}" : local.slurm_database.private_ip,
  })
}


## the ami to use

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

## the gateway server

resource "aws_instance" "gateway" {
  instance_type = var.aws_instance_type
  ami           = data.aws_ami.ami.id

  disable_api_termination     = false
  associate_public_ip_address = true
  source_dest_check           = false

  subnet_id                   = aws_subnet.public.id
  key_name                    = var.studio_code
  vpc_security_group_ids      = [aws_security_group.public.id]

  tags = {
    Name = "${var.studio_code}-gw"
  }
  
  depends_on = [
    aws_key_pair.ssh_key
  ]
  
  user_data = <<-EOF
  #!/usr/bin/env bash
  hostnamectl set-hostname gateway
  EOF
}


## the slurm controller instance

resource "aws_instance" "controller" {
  instance_type = var.aws_instance_type
  ami           = data.aws_ami.ami.id

  disable_api_termination     = false
  associate_public_ip_address = false
  source_dest_check           = true

  subnet_id                   = aws_subnet.private.id
  key_name                    = var.studio_code
  vpc_security_group_ids      = [aws_security_group.private.id]

  tags = {
    Name = "${var.studio_code}-slurmctl"
  }
  
  depends_on = [
    aws_key_pair.ssh_key
  ]
  
  user_data = <<-EOF
  #!/usr/bin/env bash
  hostnamectl set-hostname slurmctl
  EOF
}

locals {
  # NOTE: this is ignored... can't use it to find the
  #       disk inside ansible
  nfs_server_disk = "/dev/sdf"
}

resource "aws_ebs_volume" "projects" {
  availability_zone = local.aws_availability_zone
  size = 20
  
  tags = {
    Name= "${var.studio_code}-projects"
  }
}

resource "aws_volume_attachment" "projects" {
  device_name = local.nfs_server_disk
  volume_id = aws_ebs_volume.projects.id
  instance_id = aws_instance.controller.id
}


## the slurm database instance

resource "aws_instance" "database" {
  instance_type = var.aws_instance_type
  ami           = data.aws_ami.ami.id

  disable_api_termination     = false
  associate_public_ip_address = false
  source_dest_check           = true

  subnet_id                   = aws_subnet.private.id
  key_name                    = var.studio_code
  vpc_security_group_ids      = [aws_security_group.private.id]

  tags = {
    Name = "${var.studio_code}-slurmdb"
  }
  
  depends_on = [
    aws_key_pair.ssh_key
  ]
  
  user_data = <<-EOF
  #!/usr/bin/env bash
  hostnamectl set-hostname slurmdb
  EOF
}


## the slurm worker instances

resource "aws_instance" "workers" {
  count = var.num_workers
  
  instance_type = var.aws_instance_type
  ami           = data.aws_ami.ami.id

  disable_api_termination     = false
  associate_public_ip_address = false
  source_dest_check           = true

  subnet_id                   = aws_subnet.private.id
  key_name                    = var.studio_code
  vpc_security_group_ids      = [aws_security_group.private.id]

  tags = {
    Name = "${var.studio_code}-${format("slurm-%02d", count.index)}"
  }
  
  depends_on = [
    aws_key_pair.ssh_key
  ]
  
  user_data = <<-EOF
  #!/usr/bin/env bash
  hostnamectl set-hostname ${format("slurm-%02d", count.index)}
  EOF
}
