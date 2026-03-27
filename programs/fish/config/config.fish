set -gx PATH /home/maxen/.local/bin $PATH

oh-my-posh init fish --config ~/.cache/oh-my-posh/themes/custom_quick-term.omp.json | source


if status is-interactive
    # Commands to run in interactive sessions can go here
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/maxen/miniforge3/bin/conda
    eval /home/maxen/miniforge3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/maxen/miniforge3/etc/fish/conf.d/conda.fish"
        . "/home/maxen/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/maxen/miniforge3/bin" $PATH
    end
end
# <<< conda initialize <<<

# Aliases
alias q='exit'

## Git
alias g='git'
alias gs='git status'
alias ga='git add .'
alias gc='git commit'
alias gca='git commit --all'
alias gcoan='git commit --amend --no-edit'
alias gcoa='git commit --amend'