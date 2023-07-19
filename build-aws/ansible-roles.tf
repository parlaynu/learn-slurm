## role names

locals {
  server_role = "server"
  gateway_role = "gateway"
  munge_role = "munge"
  db_server_role = "db-server"
  db_client_role = "db-client"
  db_schema_role = "db-schema"
  slurmbase_role = "slurmbase"
  slurmctl_role = "slurmctl"
  slurmdb_role = "slurmdb"
  slurmd_role = "slurmd"
  nfs_server_role = "nfs-server"
  nfs_client_role = "nfs-client"
}


resource "template_dir" "server" {
  source_dir      = "templates/ansible-roles/${local.server_role}"
  destination_dir = "local/ansible/roles/${local.server_role}"

  vars = {}
}

resource "template_dir" "gateway" {
  source_dir      = "templates/ansible-roles/${local.gateway_role}"
  destination_dir = "local/ansible/roles/${local.gateway_role}"

  vars = {}
}

resource "template_dir" "munge" {
  source_dir      = "templates/ansible-roles/${local.munge_role}"
  destination_dir = "local/ansible/roles/${local.munge_role}"

  vars = {}
}

