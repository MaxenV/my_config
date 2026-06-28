#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
FISH_BIN="$(command -v fish)"

sudo apt update
sudo apt install -y curl fish
curl -s https://ohmyposh.dev/install.sh | bash -s
export PATH="$PATH:$HOME/.local/bin"

mkdir -p ~/.config/fish
mkdir -p "$HOME/.cache/oh-my-posh/themes"
ln -sf "$SCRIPT_DIR/config/config.fish" ~/.config/fish/config.fish
ln -sf "$SCRIPT_DIR/config/custom_quick-term.omp.json" "$HOME/.cache/oh-my-posh/themes/custom_quick-term.omp.json"

oh-my-posh init fish --config "$HOME/.cache/oh-my-posh/themes/custom_quick-term.omp.json" | source

# oh-my-posh font install Hack

echo "Fish is installed at: $FISH_BIN"
echo "Set your login shell manually if you want fish to start on login: chsh -s \"$FISH_BIN\""

