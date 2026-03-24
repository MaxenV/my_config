#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
HELPERS_FILE="$SCRIPT_DIR/../../utils/helpers.sh"

# shellcheck disable=SC1090
source "$HELPERS_FILE"

installations(){
    step_start "Install kitty requirements"
    sudo apt install kitty
    pretty_text "Success installing"
}

config(){
    step_start "Copy kitty config"
    mkdir -p ~/.config/kitty
    cp "$CONFIG_DIR/kitty.conf" ~/.config/kitty/kitty.conf
    cp "$CONFIG_DIR/GruvBox_DarkHard.conf" ~/.config/kitty/GruvBox_DarkHard.conf
    cp "$CONFIG_DIR/mappings.conf" ~/.config/kitty/mappings.conf
    pretty_text "Success copy"
}

main(){
    pretty_text "======> Kitty process <======"
    case "$1" in
        "")
            installations
            config
            ;;
        installations|install|"-i"|"--install")
            installations
            ;;
        config|"-c"|"--config")
            config
            ;;
        *)
            echo "Uzycie: $0 [installations|config]"
            return 1
            ;;
    esac
}

main "$@"