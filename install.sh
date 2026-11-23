#!/bin/sh
# Instala la traducción al español completa de Dux Modular Shell (DMS).
# Uso: ./install.sh   (pide sudo). Repetir tras cada actualización del paquete dms.
set -eu
SRC=$(cd "$(dirname "$0")" && pwd)
DEST=/usr/share/quickshell/dms
[ -d "$DEST" ] || { echo "No se encontró $DEST (¿está instalado dms?)" >&2; exit 1; }

sudo install -m644 "$SRC/translations/es.json" "$DEST/translations/poexports/es.json"
sudo install -m644 "$SRC/translations/DCommon/es.json" "$DEST/DCommon/translations/poexports/es.json"

# DMS usa la interfaz embebida en su binario; hay que apuntarlo a $DEST.
D="$HOME/.config/systemd/user/dms.service.d"
mkdir -p "$D"
printf '[Service]\nEnvironment=DMS_SHELL_DIR=%s\n' "$DEST" > "$D/shell-dir.conf"

# Idioma de la sesión.
S="$HOME/.local/state/dms/session.json"
if [ -f "$S" ] && command -v jq >/dev/null; then
  jq '.locale="es"' "$S" > "$S.new" && mv "$S.new" "$S"
fi

systemctl --user daemon-reload
systemctl --user restart dms
echo "Listo: DMS en español."
