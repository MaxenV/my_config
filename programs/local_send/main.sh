#!/bin/env bash

set -euo pipefail

echo "Sprawdzanie najnowszej wersji LocalSend..."

API_URL="https://api.github.com/repos/localsend/localsend/releases/latest"

DEB_URL=$(curl -fsSL "$API_URL" \
  | grep '"browser_download_url"' \
  | grep 'linux-x86-64.deb' \
  | cut -d '"' -f 4)

if [ -z "$DEB_URL" ]; then
    echo "Nie udało się znaleźć pakietu .deb."
    exit 1
fi

VERSION=$(basename "$DEB_URL" | sed -E 's/LocalSend-([0-9.]+)-.*/\1/')

echo "Znaleziono wersję: $VERSION"
echo "Pobieranie..."

TMP_DEB="/tmp/localsend.deb"
wget -O "$TMP_DEB" "$DEB_URL"

echo "Instalacja..."
sudo apt update
sudo apt install -y "$TMP_DEB"

echo
echo "LocalSend $VERSION został zainstalowany."
echo "Uruchom: localsend"