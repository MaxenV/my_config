#!/usr/bin/env bash

set -euo pipefail

TMPDIR=/tmp/bitwarden-update
mkdir -p "$TMPDIR"
chmod 755 "$TMPDIR"
trap 'rm -rf "$TMPDIR"' EXIT

echo "Searching latest desktop release..."

DEB_URL=$(
    curl -s https://api.github.com/repos/bitwarden/clients/releases |
    jq -r '
        .[]
        | select(.tag_name | startswith("desktop-v"))
        | .assets[]
        | select(.name | endswith(".deb"))
        | .browser_download_url
    ' |
    head -n1
)

if [[ -z "$DEB_URL" ]]; then
    echo "No .deb package found"
    exit 1
fi

FILE="$TMPDIR/$(basename "$DEB_URL")"

echo "Downloading:"
echo "$DEB_URL"

wget -O "$FILE" "$DEB_URL"

sudo apt install -y "$FILE"

echo "Done."