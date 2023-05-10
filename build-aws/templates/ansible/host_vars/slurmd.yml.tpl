---
server_name: ${server_name}
studio_domain: ${studio_domain}

slurm_workers:
%{ for name, _ in slurm_workers ~}
- ${name}
%{ endfor ~}

all_servers:
%{ for name, address in all_servers ~}
- name: ${name}
  address: ${address}
%{ endfor ~}
