#!/bin/bash

# MOTD - Uniwersalna wersja dla VM/serwera
# Autor: Arek | motd-proxmox-status project
# Wersja: 2025-09-07

# Kolory ANSI
green="\033[0;32m"
blue="\033[0;34m"
red="\033[0;31m"
yellow="\033[1;33m"
magenta="\033[1;35m"
cyan="\033[1;36m"
reset="\033[0m"

# Nazwa hosta
HOSTNAME=$(hostname | tr '[:lower:]' '[:upper:]')

# Informacje systemowe
OS=$(lsb_release -ds 2>/dev/null || grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
CPU_LOAD=$(awk '{print $1", "$2", "$3}' /proc/loadavg)
MEMORY=$(free -h | awk '/Mem:/ {print $3" / "$2}')
DISK=$(df -h / | awk 'NR==2 {print $3" / "$2}')
USERS=$(who | wc -l)
DATETIME=$(date '+%a %b %d %H:%M:%S %Z %Y')

# Temperatura CPU (jeśli dostępna)
if command -v sensors >/dev/null 2>&1; then
  CPU_TEMP=$(sensors | grep -m 1 -E 'Tdie|Package id 0:' | awk '{print $NF}')
else
  CPU_TEMP="N/A"
fi

# Styl baneru: figlet lub toilet
# Można ustawić BANNER_STYLE="figlet" lub "toilet"
BANNER_STYLE="figlet"

# Funkcja do wyświetlenia kolorowego baneru
function print_banner() {
  echo ""
  # Znajdź lolcat (czasem instalowany jako /usr/games/lolcat)
  local LOLCAT_BIN=""
  if command -v lolcat >/dev/null 2>&1; then
    LOLCAT_BIN="$(command -v lolcat)"
  elif [[ -x /usr/games/lolcat ]]; then
    LOLCAT_BIN="/usr/games/lolcat"
  fi

  case "$BANNER_STYLE" in
    figlet)
      if command -v figlet >/dev/null 2>&1; then
        if [[ -n "$LOLCAT_BIN" ]]; then
          figlet "$HOSTNAME" | "$LOLCAT_BIN"
        else
          figlet "$HOSTNAME"
        fi
      else
        echo -e "${yellow}$HOSTNAME${reset}"
      fi
      ;;
    toilet)
      if command -v toilet >/dev/null 2>&1; then
        if [[ -n "$LOLCAT_BIN" ]]; then
          toilet -f mono12 "$HOSTNAME" --filter border:metal | "$LOLCAT_BIN"
        else
          toilet -f mono12 "$HOSTNAME" --filter border:metal
        fi
      else
        echo -e "${yellow}$HOSTNAME${reset}"
      fi
      ;;
    *)
      echo -e "${yellow}$HOSTNAME${reset}"
      ;;
  esac
  echo ""
}

# Wyświetlenie baneru i informacji
clear
print_banner

echo -e "${blue}System:${reset}     $OS"
echo -e "${blue}Kernel:${reset}     $KERNEL"
echo -e "${blue}Uptime:${reset}     $UPTIME"
echo -e "${blue}Load Avg:${reset}   $CPU_LOAD"
echo -e "${blue}Memory:${reset}     $MEMORY"
echo -e "${blue}Disk:${reset}       $DISK"
echo -e "${blue}Users:${reset}      $USERS logged in"
echo -e "${blue}CPU Temp:${reset}   $CPU_TEMP"
echo -e "${blue}Hostname:${reset}   $HOSTNAME"
echo -e "${blue}Time:${reset}       $DATETIME"
echo
