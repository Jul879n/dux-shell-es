#!/bin/sh
# Instala la traducción al español completa de Dux Modular Shell (DMS).
# Uso: ./install.sh   (pide sudo). Deja además un hook de dnf5 que la reaplica
# tras cada actualización del paquete dms.
set -eu
SRC=$(cd "$(dirname "$0")" && pwd)
DEST=/usr/share/quickshell/dms
[ -d "$DEST" ] || { echo "No se encontró $DEST (¿está instalado dms?)" >&2; exit 1; }

# Copia fija en /usr/local para que el hook no dependa de dónde se clonó el repo.
LIB=/usr/local/share/dux-shell-es
sudo mkdir -p "$LIB/translations/DCommon"
sudo install -m644 "$SRC/translations/es.json" "$LIB/translations/es.json"
sudo install -m644 "$SRC/translations/DCommon/es.json" "$LIB/translations/DCommon/es.json"
sudo install -m755 "$SRC/apply.sh" "$LIB/apply.sh"
sudo "$LIB/apply.sh"

# Hook de dnf5: reaplica tras instalar/actualizar dms.
if [ -d /etc/dnf/libdnf5-plugins/actions.d ]; then
  printf 'post_transaction:dms:in::%s\n' "$LIB/apply.sh" |
    sudo tee /etc/dnf/libdnf5-plugins/actions.d/dux-shell-es.actions >/dev/null
fi

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
