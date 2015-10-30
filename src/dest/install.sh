#!/usr/bin/env sh
#
# install script

prog_dir="$(dirname "$(realpath "${0}")")"
name="$(basename "${prog_dir}")"
tmp_dir="/tmp/DroboApps/${name}"
logfile="${tmp_dir}/install.log"

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o xtrace   # enable script tracing

# check firmware version
if ! /usr/bin/DroboApps.sh sdk_version &> /dev/null; then
  echo "Unsupported Drobo firmware, please upgrade to the latest version." > "${statusfile}"
  echo "4" > "${errorfile}"
fi

# install apache 2+
/usr/bin/DroboApps.sh install_version apache 2

# install mysql 5.6.26+
/usr/bin/DroboApps.sh install_version mysql 5.6.26

# create wordpress password
openssl="/mnt/DroboFS/Shares/DroboApps/apache/libexec/openssl"
wordpass="$(${openssl} rand -hex 10)"
echo "${wordpass}" > "${prog_dir}/etc/.mysql_password"
chmod 600 "${prog_dir}/etc/.mysql_password"

if /mnt/DroboFS/Shares/DroboApps/mysql/scripts/mysql_db_exists.sh -n wordpress; then
  # update wordpress password
  /mnt/DroboFS/Shares/DroboApps/mysql/scripts/mysql_change_password.sh -n wordpress -u wordpress -p "${wordpass}"
else
  # create wordpress database
  /mnt/DroboFS/Shares/DroboApps/mysql/scripts/mysql_create_db.sh -n wordpress -u wordpress -p "${wordpass}"
fi

# generate wp-config.php
cp -vf "${prog_dir}/app/wp-config.php.template" "${prog_dir}/app/wp-config.php"
sed -e "s|##0##|${wordpass}|g" -i "${prog_dir}/app/wp-config.php"
for i in $(seq 1 8); do
  key="$("${openssl}" rand -base64 48)"
  sed -e "s|##${i}##|${key}|g" -i "${prog_dir}/app/wp-config.php"
done

# copy default configuration files
find "${prog_dir}" -type f -name "*.default" -print | while read deffile; do
  basefile="$(dirname "${deffile}")/$(basename "${deffile}" .default)"
  if [ ! -f "${basefile}" ]; then
    cp -vf "${deffile}" "${basefile}"
  fi
done
