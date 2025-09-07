# MOTD Proxmox & Universal Status

Skrypt MOTD do wyświetlania estetycznych informacji systemowych przy logowaniu na serwer przez SSH lub lokalnie.

## 📂 Zawartość repozytorium

- `motd-proxmox.sh` – dedykowany dla węzłów Proxmox
- `motd-generic.sh` – uniwersalna wersja dla każdej maszyny (VM, LXC, bare-metal)
- `install.sh` – instalator skryptu i zależności

## 🧩 Wymagania

Skrypt wymaga następujących pakietów (zostaną zainstalowane przez `install.sh`):

```bash
apt install figlet lolcat toilet lsb-release lm-sensors -y
```

## 🖥️ Instalacja

Uruchom jako root:

```bash
git clone https://github.com/TwojUser/motd-proxmox-status.git
cd motd-proxmox-status
chmod +x install.sh
./install.sh
```

## ⚙️ Konfiguracja

W `motd-generic.sh` możesz ustawić styl baneru:

```bash
BANNER_STYLE="figlet"   # lub "toilet"
```

Możesz też dodać flagę `DEBUG` w przyszłości, by wyłączyć banner w skryptach automatycznych.

---

Autor: Arek • PSK‑NET  
Repozytorium: [github.com/TwojUser/motd-proxmox-status](https://github.com/TwojUser/motd-proxmox-status)
