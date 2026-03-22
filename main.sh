#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HELPERS_FILE="$SCRIPT_DIR/utils/helpers.sh"

# shellcheck disable=SC1090
source "$HELPERS_FILE"

pretty_text "======> Main process <======"
step_start "Running kitty module"

"$SCRIPT_DIR/programs/kitty/kitty_main.sh" "$@"
