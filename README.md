# MOTD Proxmox & Universal Status

Prosty i czytelny MOTD (Message of the Day), który wyświetla kluczowe informacje o systemie podczas logowania (SSH lub lokalnie). Dostępne są dwie wersje: dedykowana dla węzłów Proxmox oraz uniwersalna dla dowolnej maszyny (VM, LXC, bare‑metal).

![Baner MOTD](banner.png)

## ✨ Funkcje

- Kolorowy baner z nazwą hosta (Figlet/Toilet + Lolcat)
- Czytelne metryki: system, kernel, uptime, load, pamięć, dysk, użytkownicy, czas
- Odczyt temperatury CPU (jeśli dostępne `lm-sensors`)
- Wersja Proxmox: lista VM i informacje o klastrze
- (Opcjonalnie) alerty Telegram dla wersji Proxmox

## 📂 Zawartość repozytorium

- `motd-proxmox.sh` – dedykowany dla węzłów Proxmox
- `motd-generic.sh` – uniwersalna wersja dla każdej maszyny (VM, LXC, bare-metal)
- `install.sh` – instalator skryptu i zależności

## 🧩 Wymagania

Skrypt wymaga następujących pakietów (mogą zostać zainstalowane przez `install.sh`):

```bash
apt install -y figlet lolcat toilet lsb-release lm-sensors
```

## 🖥️ Instalacja

Uruchom jako root (lub z `sudo`):

```bash
git clone https://github.com/TwojUser/motd-proxmox-status.git
cd motd-proxmox-status
chmod +x install.sh
sudo ./install.sh
```

Instalator zapyta, którą wersję zainstalować i umieści skrypt w `/etc/update-motd.d/`.

## ⚙️ Konfiguracja

W `motd-generic.sh` możesz ustawić styl baneru:

```bash
BANNER_STYLE="figlet"   # lub "toilet"
```

Wersja Proxmox (`motd-proxmox.sh`) obsługuje (opcjonalnie) powiadomienia Telegram. Aby je włączyć, uzupełnij na górze pliku:

```bash
BOT_TOKEN=""
CHAT_ID=""
```

> Uwaga: Alerty są wysyłane tylko, gdy istnieją komunikaty (np. zatrzymane VM lub dużo aktualizacji) i oba pola są wypełnione.

## 🖼️ Podgląd

Przykładowy widok panelu informacyjnego:

![Panel przykładowy](panel.png)

## 🧹 Odinstalowanie

Usuń odpowiedni plik z katalogu `update-motd.d`:

```bash
sudo rm -f /etc/update-motd.d/10-proxmox
sudo rm -f /etc/update-motd.d/10-generic
```

---

Autor: Arek • PSK‑NET  
Repozytorium: [github.com/TwojUser/motd-proxmox-status](https://github.com/TwojUser/motd-proxmox-status)
