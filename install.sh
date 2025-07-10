#!/bin/bash

echo "🔧 Instalacja wymaganych pakietów..."
apt update
apt install -y figlet lolcat curl lm-sensors lsb-release

echo "📄 Instalacja skryptu MOTD..."
cp motd-proxmox.sh /etc/profile.d/motd-proxmox.sh
chmod +x /etc/profile.d/motd-proxmox.sh

echo "✅ Gotowe. Zaloguj się ponownie, aby zobaczyć efekt MOTD."
