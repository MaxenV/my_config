#!/bin/bash

sudo apt install fish
curl -s https://ohmyposh.dev/install.sh | bash -s

mv config/config.fish ~/.config/fish/config.fish
mv config/custom_quick-term.omp.json ~/.cache/oh-my-posh/themes/custom_quick-term.omp.json

oh-my-posh init fish --config /root/.cache/oh-my-posh/themes/custom_quick-term.omp.json

oh-my-posh font install
oh-my-posh font install Hack

oh-my-posh init fish --config ~/.cache/oh-my-posh/themes/custom_quick-term.omp.json | source
