#!/bin/bash

set -euo pipefail

BOT_TOKEN="${BOT_TOKEN:-}"
CHAT_ID="${CHAT_ID:-}"

MAX_LOAD_1="${MAX_LOAD_1:-3.0}"
MAX_CPU_TEMP="${MAX_CPU_TEMP:-85}"
MIN_ROOT_FREE_GB="${MIN_ROOT_FREE_GB:-5}"
MAX_UPGRADES="${MAX_UPGRADES:-50}"

alerts=()

load1=$(awk '{print $1}' /proc/loadavg)
if awk -v l="$load1" -v m="$MAX_LOAD_1" 'BEGIN{exit !(l>m)}'; then
  alerts+=("Wysokie obciążenie: load1=$load1 > $MAX_LOAD_1")
fi

if command -v sensors >/dev/null 2>&1; then
  cpu_t=$(sensors | grep -m1 -E 'Tdie|Package id 0:' | sed -E 's/.*\+([0-9]+)\..*C.*/\1/' || true)
  if [[ -n "${cpu_t:-}" ]] && [[ "$cpu_t" -gt "$MAX_CPU_TEMP" ]]; then
    alerts+=("Wysoka temperatura CPU: ${cpu_t}C > ${MAX_CPU_TEMP}C")
  fi
fi

free_gb=$(df -BG / | awk 'NR==2{gsub("G","",$4); print $4}')
if [[ -n "${free_gb:-}" ]] && [[ "$free_gb" -lt "$MIN_ROOT_FREE_GB" ]]; then
  alerts+=("Mało miejsca na /: ${free_gb}GB < ${MIN_ROOT_FREE_GB}GB")
fi

upgrades=$(apt list --upgradable 2>/dev/null | grep -v Listing | wc -l | tr -d ' ')
if [[ "${upgrades:-0}" -ge "$MAX_UPGRADES" ]]; then
  alerts+=("Dostępnych aktualizacji: $upgrades >= $MAX_UPGRADES")
fi

if command -v systemctl >/dev/null 2>&1; then
  failed_units=$(systemctl --failed --no-legend | awk '{print $1" ("$2")"}')
  if [[ -n "${failed_units:-}" ]]; then
    alerts+=("Usługi w stanie failed:\n${failed_units}")
  fi
fi

if [[ ${#alerts[@]} -eq 0 ]]; then
  exit 0
fi

if [[ -z "${BOT_TOKEN}" || -z "${CHAT_ID}" ]]; then
  echo "[monitor-generic] Wykryto alerty, ale brak BOT_TOKEN/CHAT_ID." >&2
  printf '%s\n' "${alerts[@]}" >&2
  exit 1
fi

HOSTNAME_FQDN=$(hostname -f 2>/dev/null || hostname)
MESSAGE="🚨 Alerty: ${HOSTNAME_FQDN}"
for a in "${alerts[@]}"; do
  MESSAGE+=$'\n''• '"${a}"
done

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d chat_id="${CHAT_ID}" \
  -d parse_mode="Markdown" \
  --data-urlencode text="${MESSAGE}" >/dev/null 2>&1 || true
