[gateways]
${gateway.name}

[mungers]
${slurm_controller.name}
${slurm_database.name}
%{ for name, _ in slurm_workers ~}
${name}
%{ endfor ~}

[controllers]
${slurm_controller.name}

[databases]
${slurm_database.name}

[workers]
%{ for name, _ in slurm_workers ~}
${name}
%{ endfor ~}
