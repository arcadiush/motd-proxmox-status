#!/bin/bash

# 🔧 KONFIGURACJA
BOT_TOKEN=""
CHAT_ID=""

# Nagłówek: nazwa hosta (np. PROXMOX2) z fallbackiem, gdy brak lolcat
HOSTNAME_UPPER=$(hostname | tr '[:lower:]' '[:upper:]')
# Znajdź lolcat nawet jeśli nie ma go w PATH (często /usr/games/lolcat)
LOLCAT_BIN=""
if command -v lolcat >/dev/null 2>&1; then
  LOLCAT_BIN="$(command -v lolcat)"
elif [[ -x /usr/games/lolcat ]]; then
  LOLCAT_BIN="/usr/games/lolcat"
fi

if command -v figlet >/dev/null 2>&1; then
  if [[ -n "$LOLCAT_BIN" ]]; then
    figlet -w 120 "$HOSTNAME_UPPER" | "$LOLCAT_BIN"
  else
    figlet -w 120 "$HOSTNAME_UPPER"
  fi
else
  echo -e "\e[1;33m$HOSTNAME_UPPER\e[0m"
fi

# Informacje o systemie
echo
echo -e "\e[1;34mSystem:\e[0m $(lsb_release -ds 2>/dev/null || grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)"
echo -e "\e[1;34mKernel:\e[0m $(uname -r)"
echo -e "\e[1;34mUptime:\e[0m $(uptime -p)"
echo -e "\e[1;34mLoad:\e[0m $(uptime | awk -F'load average:' '{ print $2 }')"
echo -e "\e[1;34mMemory:\e[0m $(free -h | awk '/^Mem:/ {print $3 " / " $2}')"
echo -e "\e[1;34mDisk:\e[0m $(df -h / | awk 'NR==2 {print $3 " / " $2 " used"}')"
echo -e "\e[1;34mUsers:\e[0m $(who | wc -l) currently logged in"
echo -e "\e[1;34mLocal IP:\e[0m $(hostname -I | awk '{print $1}')"
echo -e "\e[1;34mPublic IP:\e[0m $(curl -s ifconfig.me)"
echo -e "\e[1;34mHostname:\e[0m $(hostname -f)"
echo -e "\e[1;34mProxmox:\e[0m $(pveversion | head -n 1)"

# Informacje o klastrze
if command -v pvecm >/dev/null; then
  echo -e "\e[1;34mCluster:\e[0m"
  echo -e "Nodes: $(pvecm nodes | tail -n +2 | wc -l)"
fi

# Lista VM
printf "\n--- VM ---\n"
printf "%-8s %-20s %-10s %-10s\n" "VMID" "NAME" "STATUS" "MEM(MB)"
ALERTS=()
qm list | tail -n +2 | while read -r vmid name status mem rest; do
  if [[ "$status" == "running" ]]; then
    status_color="\e[1;32m"
  else
    status_color="\e[1;31m"
    ALERTS+=("VM $vmid jest w stanie: $status")
  fi
  printf "%-8s %-20s ${status_color}%-10s\e[0m %-10s\n" "$vmid" "$name" "$status" "$mem"
done

# --- TEMPERATURA CPU ---
cpu_temp=$(sensors 2>/dev/null | grep -m1 'Package id 0:' | awk '{print $4}')
[[ -z "$cpu_temp" ]] && cpu_temp="N/A"
echo -e "\n\e[1;34mCPU Temp:\e[0m $cpu_temp"

# --- APT UPDATE ---
updates=$(apt list --upgradable 2>/dev/null | grep -v Listing | wc -l)
echo -e "\e[1;34mAPT Updates:\e[0m $updates package(s) can be upgraded"

# --- CZAS ---
echo -e "\e[1;34mTime:\e[0m $(date)"

# MOTD stopka
echo -e "\n\e[1;30mMOTD by Arkadiusz Sobacki | PSK-NET\e[0m"

# --- ALERTY DO TELEGRAMA ---
[[ $updates -gt 50 ]] && ALERTS+=("Dostępnych aktualizacji: $updates")

if [[ ${#ALERTS[@]} -gt 0 && -n "$BOT_TOKEN" && -n "$CHAT_ID" ]]; then
  MESSAGE="🚨 *Alert z serwera: $(hostname)*"
  for alert in "${ALERTS[@]}"; do
    MESSAGE+=$'\n''• '"$alert"
  done

  curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d parse_mode="Markdown" \
    -d text="${MESSAGE}" > /dev/null
fi
