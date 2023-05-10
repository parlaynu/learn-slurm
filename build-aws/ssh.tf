locals {
  ssh_key_file = "local/pki/${var.studio_code}"
  ssh_cfg_file = "local/ssh.cfg"
}


resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_private_key" {
  content         = tls_private_key.ssh_key.private_key_openssh
  filename        = local.ssh_key_file
  file_permission = "0600"
}


resource "local_file" "ssh_config" {
  content = templatefile("templates/ssh.cfg.tpl", {
    ssh_key_file = local.ssh_key_file
    gateway      = local.gateway
    slurm_controller = local.slurm_controller
    slurm_database   = local.slurm_database
    slurm_workers    = local.slurm_workers
  })
  filename        = local.ssh_cfg_file
  file_permission = "0640"
}

