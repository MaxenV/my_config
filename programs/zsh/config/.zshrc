# >>>>>>>>>> Exports <<<<<<<<<<<<
export EDITOR=vim
export PATH="$HOME/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"


# >>>>>>>>>> Const config <<<<<<<<<<<<
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions fzf sudo extract)


# Completion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
autoload -U compinit && compinit

# >>>>>>>>>> Sources <<<<<<<<<<<<
source "$ZSH/oh-my-zsh.sh"
source ~/.secrets/main_secrets.sh

# Load powerlevel10k config
[ -f "$HOME/.p10k.zsh" ] && source "$HOME/.p10k.zsh"


# >>>>>>>>>> Aliases <<<<<<<<<<<<
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias q='exit'


#END OF CONFIG