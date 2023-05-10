---
server_name: ${server_name}
studio_domain: ${studio_domain}

all_servers:
%{ for name, address in all_servers ~}
- name: ${name}
  address: ${address}
%{ endfor ~}

