# MOTD Proxmox Server Dash

Prosty, kolorowy skrypt `bash` do wyświetlania informacji o systemie Proxmox na ekranie logowania (motd), wraz z integracją Telegram.

## Wymagania

- `bash`, `figlet`, `lolcat`, `curl`, `sensors`, `lsb-release`, `pveversion`
- System: Debian / Proxmox VE
- Opcjonalnie: Telegram bot (`BOT_TOKEN`, `CHAT_ID`)

## Instalacja

1. Zainstaluj wymagane pakiety:
   ```bash
   apt install figlet lolcat curl lm-sensors lsb-release -y
   ```
2. Skopiuj skrypt:
   ```bash
   cp motd-proxmox.sh /etc/profile.d/motd-proxmox.sh
   chmod +x /etc/profile.d/motd-proxmox.sh
   ```

3. (Opcjonalnie) Skonfiguruj Telegram:
   ```bash
   export BOT_TOKEN="your_bot_token"
   export CHAT_ID="your_chat_id"
   ```

## Autor

MOTD by Arek | PSK-NET
