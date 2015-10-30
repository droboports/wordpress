#!/usr/bin/env sh
#
# update script

prog_dir="$(dirname "$(realpath "${0}")")"
name="$(basename "${prog_dir}")"
tmp_dir="/tmp/DroboApps/${name}"
logfile="${tmp_dir}/update.log"

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o xtrace   # enable script tracing

/bin/sh "${prog_dir}/service.sh" stop

# update wp-config.php
if [ -f "${prog_dir}/app/wp-config.php" ] && ! grep -q "WP_SITEURL" "${prog_dir}/app/wp-config.php"; then
cat >> "${prog_dir}/app/wp-config.php" << "EOF"
if (isset($_SERVER['HTTPS']) && ($_SERVER['HTTPS'] == 'on' || $_SERVER['HTTPS'] == 1)
    || isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') {
  $REQUEST_SITE_URL = 'https://'.$_SERVER['HTTP_HOST'];
} else {
  $REQUEST_SITE_URL = 'http://'.$_SERVER['HTTP_HOST'];
}
define( 'WP_SITEURL', $REQUEST_SITE_URL );
define( 'WP_HOME', $REQUEST_SITE_URL );
EOF
fi
