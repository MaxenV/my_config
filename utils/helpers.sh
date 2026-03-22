#!/bin/bash

pretty_text(){
	local message="$1"
	printf "\n\033[1;36m%s\033[0m\n" "$message"
}

step_start(){
	local step_name="$1"
	printf "\033[1;33m[STEP]\033[0m %s\n" "$step_name"
}
