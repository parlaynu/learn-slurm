
resource "template_dir" "nfs_server" {
  source_dir      = "templates/ansible-roles/${local.nfs_server_role}"
  destination_dir = "local/ansible/roles/${local.nfs_server_role}"

  vars = {
    volume_id = trimprefix(aws_ebs_volume.projects.id, "vol-")
    export_client = var.subnet_cidr_blocks.private
  }
}

resource "template_dir" "nfs_client" {
  source_dir      = "templates/ansible-roles/${local.nfs_client_role}"
  destination_dir = "local/ansible/roles/${local.nfs_client_role}"

  vars = {
    nfs_server = local.slurm_controller.private_ip
  }
}
