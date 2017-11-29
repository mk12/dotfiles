# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Vi command-line editing
set -o vi

# Prompt
export PS1="\u:\[\033[32m\]\W\[\033[0m\]\\$ \[$(tput sgr0)\]"

# History
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Handle resize
shopt -s checkwinsize

# Tab completion
brew_completion=$(brew --prefix)/etc/bash_completion
[[ -f $brew_completion ]] && source $brew_completion

# Aliases
alias ll='ls -lahF'
alias mkdir='mkdir -p'
alias vi='nvim'
alias vim='nvim'
alias gg='git branch && git status --short'
