#!/bin/bash
set -euo pipefail

URL="https://discord.com/api/download?platform=linux&format=deb"
TMP_DIR="$(mktemp -d)"
DEB_FILE="$TMP_DIR/discord-latest.deb"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Pobieram najnowszą wersję Discorda..."

if command -v curl >/dev/null 2>&1; then
  curl -L --fail "$URL" -o "$DEB_FILE"
elif command -v wget >/dev/null 2>&1; then
  wget -O "$DEB_FILE" "$URL"
else
  echo "Brakuje curl/wget. Instaluję curl..."
  sudo apt update
  sudo apt install -y curl
  curl -L --fail "$URL" -o "$DEB_FILE"
fi

echo "Instaluję Discorda..."
chmod 755 "$TMP_DIR"
chmod 644 "$DEB_FILE"
sudo apt install -y "$DEB_FILE"

echo "Gotowe. Discord został zainstalowany/zaktualizowany."