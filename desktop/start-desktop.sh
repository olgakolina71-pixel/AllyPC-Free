#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed or not available in this Codespace."
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose v2 is required (docker compose)."
  exit 1
fi

if [ ! -f .env ]; then
  if command -v openssl >/dev/null 2>&1; then
    PASSWORD="$(openssl rand -hex 12)"
  else
    PASSWORD="$(head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n')"
  fi
  umask 077
  printf 'DESKTOP_USER=player\nDESKTOP_PASSWORD=%s\n' "$PASSWORD" > .env
  echo "Created a private desktop password. Save it somewhere safe:"
  echo "$PASSWORD"
else
  echo "Using the existing desktop password stored in desktop/.env"
fi

docker compose up -d
echo
echo "Desktop container started."
echo "In Codespaces, open the Ports tab and open port 3000 in your browser."
echo "Keep port visibility Private. Log in with username 'player' and the password shown above."
