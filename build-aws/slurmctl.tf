
resource "template_dir" "slurmctl" {
  source_dir      = "templates/ansible-roles/${local.slurmctl_role}"
  destination_dir = "local/ansible/roles/${local.slurmctl_role}"

  vars = {
    cluster_name = "studio"
    slurmctl_host = local.slurm_controller.name
    slurmdbd_host = local.slurm_database.name
    slurmdbd_port = 6819
    slurmdbd_user = local.db_user
    slurmdb_host = local.slurm_database.name
    slurmdb_port = 3306
    slurmdb_user = local.db_user
    slurmdb_password = local.db_user_password
    slurmdb_db = local.db_name_slurmdb
    partition_name = "studio"
  }
}

resource "local_file" "slurmctl_hostvars" {
  content = templatefile("templates/ansible/host_vars/slurmctl.yml.tpl", {
    server_name = local.slurm_controller.name
    studio_domain = var.studio_domain
    slurm_workers = local.slurm_workers
    all_servers = local.all_servers
  })

  filename        = "local/ansible/host_vars/${local.slurm_controller.name}.yml"
  file_permission = "0640"
}

