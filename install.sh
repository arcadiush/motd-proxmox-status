#!/bin/bash

set -e

# Tryb: automatyczny z możliwością wymuszenia wariantu
# Priorytet: $1 (argument) > $INSTALL_VARIANT (env) > autodetekcja

VARIANT="${1:-${INSTALL_VARIANT:-}}"

if [[ -z "$VARIANT" ]]; then
  if command -v pveversion >/dev/null 2>&1 || [[ -d /etc/pve ]]; then
    VARIANT="proxmox"
  else
    VARIANT="generic"
  fi
fi

case "$VARIANT" in
  proxmox|pve|proxmox-ve)
    VARIANT="proxmox"
    ;;
  generic|uni|universal)
    VARIANT="generic"
    ;;
  *)
    echo "❌ Nieznany wariant: '$VARIANT'. Dozwolone: proxmox | generic"
    exit 1
    ;;
esac

echo "🔧 Instalacja zależności..."
apt update
apt install -y figlet lolcat toilet lsb-release lm-sensors

mkdir -p /etc/update-motd.d

if [[ "$VARIANT" == "proxmox" ]]; then
  cp motd-proxmox.sh /etc/update-motd.d/10-proxmox
  chmod +x /etc/update-motd.d/10-proxmox
  echo "✅ Zainstalowano wersję Proxmox. (wariant: $VARIANT)"
else
  cp motd-generic.sh /etc/update-motd.d/10-generic
  chmod +x /etc/update-motd.d/10-generic
  echo "✅ Zainstalowano wersję uniwersalną. (wariant: $VARIANT)"
fi

install_bin() {
  local src="$1"; local dst="$2"
  if [[ -f "$src" ]]; then
    install -m 0755 "$src" "$dst"
    echo "✅ Zainstalowano: $dst"
  fi
}

mkdir -p /usr/local/bin
install_bin monitor-proxmox.sh /usr/local/bin/monitor-proxmox.sh
install_bin monitor-generic.sh /usr/local/bin/monitor-generic.sh

echo "ℹ️  Możesz wymusić wariant: 'INSTALL_VARIANT=proxmox bash install.sh' lub 'bash install.sh generic'"
echo "ℹ️  Skrypty monitorujące (jeśli obecne) zostały skopiowane do /usr/local/bin/."
