#!/bin/bash

set -e

# Tryb: automatyczny z możliwością wymuszenia wariantu
# Priorytet: $1 (argument) > $INSTALL_VARIANT (env) > autodetekcja

VARIANT="${1:-${INSTALL_VARIANT:-}}"
DISABLE_UNAME="${INSTALL_DISABLE_UNAME:-0}"
CONFIG_DIR="/etc/motd-status"
CONFIG_FILE="${CONFIG_DIR}/config"

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

install_deps() {
  if command -v apt >/dev/null 2>&1; then
    apt update && apt install -y figlet lolcat toilet lsb-release lm-sensors
    return
  fi
  if command -v dnf >/dev/null 2>&1; then
    dnf install -y figlet lolcat toilet redhat-lsb-core lm_sensors || true
    return
  fi
  if command -v yum >/dev/null 2>&1; then
    yum install -y figlet lolcat toilet redhat-lsb-core lm_sensors || true
    return
  fi
  if command -v zypper >/dev/null 2>&1; then
    zypper install -y figlet lolcat toilet lsb-release sensors || true
    return
  fi
  if command -v pacman >/dev/null 2>&1; then
    pacman -Sy --noconfirm figlet lolcat toilet lsb-release lm_sensors || true
    return
  fi
  if command -v apk >/dev/null 2>&1; then
    apk add --no-cache figlet lolcat toilet lsb-release lm-sensors || true
    return
  fi
  echo "⚠️  Nie wykryto wspieranego menedżera pakietów. Pomijam instalację zależności." >&2
}

install_deps || true

mkdir -p /etc/update-motd.d
mkdir -p "$CONFIG_DIR"

if [[ "$VARIANT" == "proxmox" ]]; then
  install -m 0755 motd-proxmox.sh /etc/update-motd.d/10-proxmox
  echo "✅ Zainstalowano wersję Proxmox. (wariant: $VARIANT)"
else
  install -m 0755 motd-generic.sh /etc/update-motd.d/10-generic
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

if [[ "$DISABLE_UNAME" == "1" ]] && [[ -x /etc/update-motd.d/10-uname ]]; then
  chmod -x /etc/update-motd.d/10-uname || true
  echo "ℹ️  Wyłączono /etc/update-motd.d/10-uname (INSTALL_DISABLE_UNAME=1)"
fi

# Utwórz bezpieczny plik konfiguracyjny, nie nadpisuj jeśli istnieje
if [[ ! -f "$CONFIG_FILE" ]]; then
  cat >"$CONFIG_FILE" <<'CONF'
# Konfiguracja MOTD/monitoringu (Telegram i progi)
# Uprawnienia: chmod 600 /etc/motd-status/config

# Telegram
BOT_TOKEN=""
CHAT_ID=""

# Progi (domyślne)
MAX_LOAD_1=4.0
MAX_CPU_TEMP=85
MIN_ROOT_FREE_GB=5
MAX_UPGRADES=50
CONF
  chmod 600 "$CONFIG_FILE" || true
  echo "✅ Utworzono plik konfiguracyjny: $CONFIG_FILE (pamiętaj o uzupełnieniu BOT_TOKEN/CHAT_ID)"
else
  echo "ℹ️  Wykryto istniejącą konfigurację: $CONFIG_FILE (pozostawiono bez zmian)"
fi
