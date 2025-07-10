# MOTD Proxmox Server Dash

Prosty, kolorowy skrypt `bash` do wyświetlania informacji o systemie Proxmox na ekranie logowania (motd), wraz z integracją Telegram.

## 📦 Wymagania

- System operacyjny: **Debian / Proxmox VE**
- Narzędzia:
  - `bash`, `figlet`, `lolcat`, `curl`, `sensors`, `lsb-release`, `pveversion`

## ✅ Instalacja

1. Zainstaluj wymagane pakiety:

    ```bash
    apt update
    apt install -y figlet lolcat curl lm-sensors lsb-release
    ```

2. Skrypt możesz zainstalować ręcznie:

    ```bash
    cp motd-proxmox.sh /etc/profile.d/motd-proxmox.sh
    chmod +x /etc/profile.d/motd-proxmox.sh
    ```

    Lub uruchamiając automatycznie:

    ```bash
    chmod +x install.sh
    ./install.sh
    ```

3. (Opcjonalnie) Ustaw dane do Telegrama:

    W pliku `motd-proxmox.sh` podaj:
    ```bash
    BOT_TOKEN="twoj_token"
    CHAT_ID="twoje_chat_id"
    ```

## 🖼 Podgląd

![Banner](banner.png)

## ✍️ Autor

MOTD by Arek | PSK-NET
