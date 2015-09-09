### WRODPRESS ###
_build_wordpress() {
local VERSION="4.3"
local FOLDER="wordpress"
local FILE="${FOLDER}-${VERSION}.tar.gz"
local URL="https://wordpress.org/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
mkdir -p "${DEST}/app"
cp -vfaR "target/${FOLDER}/"* "${DEST}/app/"
}

_build() {
  _build_wordpress
  _package
}
