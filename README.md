# MOTD Proxmox Server Dashboard

Kolorowy i funkcjonalny `motd` dashboard dla serwerów z systemem **Proxmox (Debian)**. Wyświetla szczegóły systemu, klastra, maszyn wirtualnych i opcjonalnie wysyła powiadomienia na Telegram.

![MOTD Screenshot](banner.png)

---

## ✨ Funkcje

- Informacje o systemie, klastrze i zasobach
- Lista maszyn wirtualnych (VM) z kolorowym statusem
- Temperatura CPU, dostępne aktualizacje, obciążenie, użytkownicy
- Powiadomienia Telegram o stanie maszyn i aktualizacjach (opcjonalne)
- Automatyczna instalacja przez `install.sh`

---

## 🛠️ Wymagania

System: **Debian / Proxmox VE**

Pakiety wymagane:
```bash
apt update && apt install figlet lolcat curl lm-sensors lsb-release -y
```

---

## 🚀 Instalacja

1. Klonuj repozytorium:

```bash
git clone https://github.com/arcadiush/motd-proxmox-status.git
cd motd-proxmox-status
```

2. Uruchom instalator:

```bash
chmod +x install.sh
./install.sh
```

3. Zaloguj się ponownie, by zobaczyć efekt 🎉

---

## Instalacja przez jedno polecenie

Wklej poniższe polecenie w terminalu, aby pobrać i uruchomić instalator:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/arcadiush/motd-proxmox-status/main/install.sh)
```

## 📩 Konfiguracja Telegram (opcjonalna)

1. Utwórz bota na [@BotFather](https://t.me/BotFather) i uzyskaj `BOT_TOKEN`.
2. Sprawdź swój `CHAT_ID` np. przez [@userinfobot](https://t.me/userinfobot).
3. W pliku `~/.bashrc` (lub `~/.profile`) dodaj:

```bash
export BOT_TOKEN="123456789:ABCdEfGhiJKlmnoPQRstUvWXYZ"
export CHAT_ID="123456789"
```

Zapisz i wykonaj `source ~/.bashrc`.

---

## 🧑‍💻 Autor

MOTD by Arek | PSK-NET

---

## 📄 Licencja

MIT License

```