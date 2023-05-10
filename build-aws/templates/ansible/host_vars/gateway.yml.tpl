---
server_name: ${server_name}
studio_domain: ${studio_domain}

public_ip: ${public_ip}

private_cidr_blocks:
%{for _, net in private_cidr_blocks ~}
- ${net}
%{ endfor ~}

all_servers:
%{ for name, address in all_servers ~}
- name: ${name}
  address: ${address}
%{ endfor ~}
