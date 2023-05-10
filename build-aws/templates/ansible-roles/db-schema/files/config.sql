CREATE DATABASE IF NOT EXISTS ${db_name_slurmdb};
CREATE DATABASE IF NOT EXISTS ${db_name_slurmacctdb};

CREATE USER IF NOT EXISTS '${db_user}'@'%' IDENTIFIED BY '${db_password}';

GRANT ALL PRIVILEGES ON ${db_name_slurmdb}.* TO '${db_user}'@'%';
GRANT ALL PRIVILEGES ON ${db_name_slurmacctdb}.* TO '${db_user}'@'%';

