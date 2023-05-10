---
- hosts: gateways
  become: yes
  gather_facts: yes
  vars:
    ansible_python_interpreter: "/usr/bin/env python3"
  tasks:
  - import_role:
      name: ${server_role}
  - import_role:
      name: ${gateway_role}


- hosts: all
  become: yes
  gather_facts: no
  vars:
    ansible_python_interpreter: "/usr/bin/env python3"
  tasks:
  - import_role:
      name: ${server_role}


- hosts: mungers
  become: yes
  gather_facts: no
  vars:
    ansible_python_interpreter: "/usr/bin/env python3"
  tasks:
  - import_role:
      name: ${munge_role}


- hosts: databases
  become: yes
  gather_facts: no
  vars:
    ansible_python_interpreter: "/usr/bin/env python3"
  tasks:
  - import_role:
      name: ${db_server_role}
  - import_role:
      name: ${db_client_role}
  - import_role:
      name: ${db_schema_role}
  - import_role:
      name: ${slurmdb_role}


- hosts: controllers
  become: yes
  gather_facts: yes
  vars:
    ansible_python_interpreter: "/usr/bin/env python3"
  tasks:
  - import_role:
      name: ${nfs_server_role}
  - import_role:
      name: ${slurmbase_role}
  - import_role:
      name: ${slurmctl_role}


- hosts: workers
  become: yes
  gather_facts: no
  vars:
    ansible_python_interpreter: "/usr/bin/env python3"
  tasks:
  - import_role:
      name: ${nfs_client_role}
  - import_role:
      name: ${slurmbase_role}
  - import_role:
      name: ${slurmd_role}


