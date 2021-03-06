### WORDPRESS ###
_build_wordpress() {
local VERSION="4.4.1"
local FOLDER="wordpress"
local FILE="${FOLDER}-${VERSION}.tar.gz"
local URL="https://wordpress.org/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
cp -vfa "src/${FOLDER}-${VERSION}-activate-plugins-on-install.patch" "target/${FOLDER}/"
pushd "target/${FOLDER}/"
patch -p1 -i "${FOLDER}-${VERSION}-activate-plugins-on-install.patch"
rm -vf "${FOLDER}-${VERSION}-activate-plugins-on-install.patch"
popd
mkdir -p "${DEST}/app"
cp -faR "target/${FOLDER}/"* "${DEST}/app/"
}

### CANONICAL REDIRECT PLUGIN ###
# https://wordpress.org/plugins/disable-canonical-url-redirects/
_build_canonical_redirect() {
local VERSION="1.0.11.0228"
local FOLDER="disable-canonical-url-redirects"
local FILE="${FOLDER}.zip"
local URL="https://downloads.wordpress.org/plugin/${FILE}"

_download_zip "${FILE}" "${URL}" "${FOLDER}"
mkdir -p "src/dest/app/wp-content/plugins"
cp -vfa "target/${FOLDER}/disable_canonical_url_redirects/"*.php "src/dest/app/wp-content/plugins/"
}

### RELATIVE URL PLUGIN ###
# https://wordpress.org/plugins/relative-url/
_build_relative_url() {
local VERSION="0.0.13"
local FOLDER="relative-url"
local FILE="${FOLDER}.${VERSION}.zip"
local URL="https://downloads.wordpress.org/plugin/${FILE}"

_download_zip "${FILE}" "${URL}" "${FOLDER}"
mkdir -p "src/dest/app/wp-content/plugins"
cp -vfa "target/${FOLDER}/"*.php "src/dest/app/wp-content/plugins/"
}

### WP CLI ###
# http://wp-cli.org/
_build_wp_cli() {
local FILE="wp-cli.phar"
local URL="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"

_download_file "${FILE}" "${URL}"
mkdir -p "src/dest/bin"
cp -vfa "download/${FILE}" "src/dest/bin/wp-cli.phar"
}

_build() {
  _build_canonical_redirect
  _build_relative_url
  _build_wp_cli
  _build_wordpress
  _package
}
