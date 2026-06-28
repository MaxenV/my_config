set -gx PATH "$HOME/.local/bin" $PATH

if type -q oh-my-posh
    oh-my-posh init fish --config "$HOME/.cache/oh-my-posh/themes/custom_quick-term.omp.json" | source
end


if status is-interactive
    # Commands to run in interactive sessions can go here
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f "$HOME/miniforge3/bin/conda"
    eval "$HOME/miniforge3/bin/conda" "shell.fish" "hook" $argv | source
else
    if test -f "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
        . "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "$HOME/miniforge3/bin" $PATH
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