
resource "template_dir" "slurmbase" {
  source_dir      = "templates/ansible-roles/${local.slurmbase_role}"
  destination_dir = "local/ansible/roles/${local.slurmbase_role}"

  vars = {}
}
