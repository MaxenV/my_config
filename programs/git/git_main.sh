#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
HELPERS_FILE="$SCRIPT_DIR/../../utils/helpers.sh"

# shellcheck disable=SC1090
source "$HELPERS_FILE"

trim_whitespace() {
	printf '%s' "$1" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'
}

merge_config_file() {
	local file_name="$1"
	local section_name="$2"
	local file_path="$CONFIG_DIR/$file_name"
	local added=0
	local exists=0
	local conflict=0
	local conflict_details=""

	step_start "Merging $file_name into [$section_name]"

	while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
		local line key value full_key

		line="$(trim_whitespace "$raw_line")"

		[[ -z "$line" || "$line" == \#* || "$line" == \;* ]] && continue

		# Remove inline comments like: key = value # comment
		line="$(printf '%s' "$line" | sed -E 's/[[:space:]]+#.*$//; s/[[:space:]]+$//')"
		[[ -z "$line" || "$line" != *"="* ]] && continue

		key="$(trim_whitespace "${line%%=*}")"
		value="$(trim_whitespace "${line#*=}")"
		full_key="$section_name.$key"

		local existing_values existing_inline
		existing_values="$(git config --global --get-all "$full_key" 2>/dev/null || true)"

		if [[ -z "$existing_values" ]]; then
			git config --global "$full_key" "$value"
			added=$((added + 1))
			continue
		fi

		if printf '%s\n' "$existing_values" | grep -Fx -- "$value" >/dev/null 2>&1; then
			exists=$((exists + 1))
			continue
		fi

		conflict=$((conflict + 1))
		existing_inline="$(printf '%s' "$existing_values" | tr '\n' ';' | sed -E 's/;+$//')"
		conflict_details+="- $full_key: existing=[$existing_inline], incoming=[$value]"$'\n'
	done < "$file_path"

	pretty_text "[$section_name] added: $added, exists: $exists, conflict: $conflict"

	if [[ -n "$conflict_details" ]]; then
		echo "Conflicts in [$section_name]:"
		printf '%s' "$conflict_details"
	fi
}

config() {
	step_start "Ensuring global git config exists"
	touch "$HOME/.gitconfig"

	merge_config_file "user.conf" "user"
	merge_config_file "aliases.conf" "alias"
	merge_config_file "init.conf" "init"
	merge_config_file "pull.conf" "pull"
	merge_config_file "core.conf" "core"

	pretty_text "Git config merge completed"
}

main() {
	pretty_text "======> Git process <======"

	case "$1" in
		""|config|"-c"|"--config")
			config
			;;
		*)
			echo "Uzycie: $0 [config]"
			return 1
			;;
	esac
}

main "$@"
