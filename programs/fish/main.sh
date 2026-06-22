#!/bin/bash

sudo apt install -y fish
curl -s https://ohmyposh.dev/install.sh | bash -s
export PATH=$PATH:~/.local/bin

mkdir -p ~/.config/fish
ln -f config/config.fish ~/.config/fish/config.fish
ln -f config/custom_quick-term.omp.json ~/.cache/oh-my-posh/themes/custom_quick-term.omp.json

oh-my-posh init fish --config /root/.cache/oh-my-posh/themes/custom_quick-term.omp.json

oh-my-posh font install Hack

# oh-my-posh init fish --config ~/.cache/oh-my-posh/themes/custom_quick-term.omp.json | source
eval "$(oh-my-posh init bash --config ~/.cache/oh-my-posh/themes/custom_quick-term.omp.json)"
chsh -s "$(which fish)"

