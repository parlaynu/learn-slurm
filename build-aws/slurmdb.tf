locals {
  db_root_password = var.db_root_password == "" ? random_password.db_root.result : var.db_root_password
  db_user_password = var.db_user_password == "" ? random_password.db_user.result : var.db_user_password
  
  db_user = "slurm"
  db_name_slurmdb = "slurm"
  db_name_slurmacctdb = "slurm_acct"
}


resource "random_password" "db_root" {
  length           = 16
  special          = true
}

resource "random_password" "db_user" {
  length           = 16
  special          = true
}

resource "template_dir" "db_server" {
  source_dir      = "templates/ansible-roles/${local.db_server_role}"
  destination_dir = "local/ansible/roles/${local.db_server_role}"

  vars = {
    root_password = local.db_root_password
  }
}

resource "template_dir" "db_client" {
  source_dir      = "templates/ansible-roles/${local.db_client_role}"
  destination_dir = "local/ansible/roles/${local.db_client_role}"

  vars = {}
}

resource "template_dir" "db_schema" {
  source_dir      = "templates/ansible-roles/${local.db_schema_role}"
  destination_dir = "local/ansible/roles/${local.db_schema_role}"

  vars = {
    db_client = var.subnet_cidr_blocks.private
    db_user = local.db_user
    db_password = local.db_user_password
    db_name_slurmdb = local.db_name_slurmdb
    db_name_slurmacctdb = local.db_name_slurmacctdb
  }
}

resource "template_dir" "slurmdb" {
  source_dir      = "templates/ansible-roles/${local.slurmdb_role}"
  destination_dir = "local/ansible/roles/${local.slurmdb_role}"

  vars = {
    slurmdb_user = local.db_user
    slurmdb_password = local.db_user_password
    slurmdb_host = "127.0.0.1"
    slurmdb_db = local.db_name_slurmacctdb
  }
}

resource "local_file" "slurmdb_hostvars" {
  content = templatefile("templates/ansible/host_vars/slurmdb.yml.tpl", {
    server_name = local.slurm_database.name
    studio_domain = var.studio_domain
    all_servers = local.all_servers
  })

  filename        = "local/ansible/host_vars/${local.slurm_database.name}.yml"
  file_permission = "0640"
}
