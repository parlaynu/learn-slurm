## render the run script

resource "local_file" "run_playbook" {
  content = templatefile("templates/ansible/run-ansible.sh.tpl", {
      inventory_file = "inventory.ini"
    })
  filename = "local/ansible/run-ansible.sh"
  file_permission = "0755"
}


## render the playbook

resource "local_file" "playbook" {
  content = templatefile("templates/ansible/playbook.yml.tpl", {
      server_role = local.server_role
      gateway_role = local.gateway_role
      munge_role = local.munge_role
      db_server_role = local.db_server_role
      db_client_role = local.db_client_role
      db_schema_role = local.db_schema_role
      slurmbase_role = local.slurmbase_role
      slurmctl_role = local.slurmctl_role
      slurmdb_role = local.slurmdb_role
      slurmd_role = local.slurmd_role
      nfs_server_role = local.nfs_server_role
      nfs_client_role = local.nfs_client_role
    })
  filename = "local/ansible/playbook.yml"
  file_permission = "0640"
}


## render the inventory file

resource "local_file" "inventory" {
  content = templatefile("templates/ansible/inventory.ini.tpl", {
    gateway = local.gateway
    slurm_controller = local.slurm_controller
    slurm_database   = local.slurm_database
    slurm_workers    = local.slurm_workers
  })
  filename = "local/ansible/inventory.ini"
  file_permission = "0640"
}

## hostvars

resource "local_file" "gateway_hostvars" {
  content = templatefile("templates/ansible/host_vars/gateway.yml.tpl", {
    server_name = local.gateway.name
    studio_domain = var.studio_domain
    public_ip   = local.gateway.public_ip
    private_cidr_blocks = [ var.vpc_cidr_block ]
    all_servers = local.all_servers
  })

  filename        = "local/ansible/host_vars/${local.gateway.name}.yml"
  file_permission = "0640"
}

