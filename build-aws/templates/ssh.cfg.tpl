
# gateway
Host ${gateway.name}
  Hostname ${gateway.public_ip}

# controller
Host ${slurm_controller.name}
  Hostname ${slurm_controller.private_ip}
  ProxyJump ${gateway.name}

# database
Host ${slurm_database.name}
  Hostname ${slurm_database.private_ip}
  ProxyJump ${gateway.name}

# workers
%{ for key, value in slurm_workers ~}
Host ${key}
  Hostname ${value}
  ProxyJump ${gateway.name}
%{ endfor ~}


Host *
  User ubuntu
  IdentityFile ${ssh_key_file}
  IdentitiesOnly yes

