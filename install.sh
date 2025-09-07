#!/bin/bash

set -e

echo "🔧 Instalacja zależności..."
apt update
apt install -y figlet lolcat toilet lsb-release lm-sensors

echo "📁 Wybór wersji skryptu:"
echo "1. Proxmox (motd-proxmox.sh)"
echo "2. Uniwersalna (motd-generic.sh)"
read -p "Wybierz wersję (1/2): " choice

case "$choice" in
  1)
    cp motd-proxmox.sh /etc/update-motd.d/10-proxmox
    chmod +x /etc/update-motd.d/10-proxmox
    echo "✅ Zainstalowano wersję Proxmox."
    ;;
  2)
    cp motd-generic.sh /etc/update-motd.d/10-generic
    chmod +x /etc/update-motd.d/10-generic
    echo "✅ Zainstalowano wersję uniwersalną."
    ;;
  *)
    echo "❌ Nieprawidłowy wybór."
    exit 1
    ;;
esac
