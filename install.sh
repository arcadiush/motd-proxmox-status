#!/bin/bash

echo "🔧 Instalacja MOTD dla Proxmox..."

# 1. Instalacja wymaganych pakietów
echo "📦 Instalacja wymaganych pakietów..."
apt update
apt install -y figlet lolcat curl lm-sensors lsb-release

# 2. Skopiowanie skryptu
echo "📁 Instalacja skryptu do /etc/profile.d/"
cp motd-proxmox.sh /etc/profile.d/
chmod +x /etc/profile.d/motd-proxmox.sh

# 3. Konfiguracja Telegram (opcjonalnie)
read -p "Czy chcesz skonfigurować powiadomienia Telegram? (t/n): " ans
if [[ "$ans" == "t" ]]; then
  read -p "Podaj BOT_TOKEN: " BOT_TOKEN
  read -p "Podaj CHAT_ID: " CHAT_ID

  echo "Eksportowanie danych do ~/.bashrc"
  echo "export BOT_TOKEN=\"$BOT_TOKEN\"" >> ~/.bashrc
  echo "export CHAT_ID=\"$CHAT_ID\"" >> ~/.bashrc
  echo "🔁 Załaduj zmienne poleceniem: source ~/.bashrc"
fi

echo "✅ Instalacja zakończona. Zaloguj się ponownie lub wpisz: bash"
