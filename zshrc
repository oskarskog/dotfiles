export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="bira"

plugins=(git zsh-z)

source $ZSH/oh-my-zsh.sh

alias ll='ls -lA'
alias vi=nvim

eval "$(starship init zsh)"
