#!/bin/sh
# Parte root: copia las traducciones y parcha textos fijos. Idempotente.
# Lo ejecuta install.sh y el hook de dnf tras cada actualización de dms.
set -eu
SRC=$(cd "$(dirname "$0")" && pwd)
DEST=/usr/share/quickshell/dms
[ -d "$DEST" ] || exit 0

install -m644 "$SRC/translations/es.json" "$DEST/translations/poexports/es.json"
install -m644 "$SRC/translations/DCommon/es.json" "$DEST/DCommon/translations/poexports/es.json"

# Textos fijos (sin I18n.tr) del modal de novedades.
C="$DEST/Modals/Changelog"
[ -f "$C/ChangelogModal.qml" ] && sed -i "s|text: \"Let's go\"|text: \"Vamos\"|" "$C/ChangelogModal.qml"
[ -f "$C/ChangelogContent.qml" ] && sed -i \
  -e "s|text: \"Move to the Dux Labs repositories\"|text: \"Cambiarse a los repositorios de Dux Labs\"|" \
  -e "s|text: \"Packaged installs now update from Dux Labs. Run dms migrate dux once, it lists every repository it moves and asks first. On Arch, pacman swaps in dux-shell on its own.\"|text: \"Las instalaciones por paquete ahora se actualizan desde Dux Labs. Ejecute dms migrate dux una vez: lista cada repositorio que mueve y consulta antes. En Arch, pacman cambia a dux-shell por sí solo.\"|" \
  "$C/ChangelogContent.qml"
