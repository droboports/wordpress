#!/usr/bin/env sh
#
# reset script

prog_dir="$(dirname "$(realpath "${0}")")"
name="$(basename "${prog_dir}")"
#data_dir="/mnt/DroboFS/Shares/DroboApps/.AppData/${name}"
tmp_dir="/tmp/DroboApps/${name}"
logfile="${tmp_dir}/reset.log"

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
#set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o xtrace   # enable script tracing

/bin/sh "${prog_dir}/service.sh" stop

"/mnt/DroboFS/Shares/DroboApps/mysql/bin/mysql" --user="wordpress" --password="$(cat "${prog_dir}/etc/.mysql_password")" wordpress << EOF
SET @tables = NULL;
SELECT GROUP_CONCAT(table_schema, '.', table_name) INTO @tables FROM information_schema.tables WHERE table_schema = 'wordpress';
SET @tables = CONCAT('DROP TABLE ', @tables);
PREPARE stmt FROM @tables;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
EOF

/bin/sh "${prog_dir}/service.sh" start
