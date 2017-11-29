# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Shell options
shopt -s checkwinsize
shopt -s histappend

# Prompt
export PS1="\u:\[\033[32m\]\W\[\033[0m\]\\$ \[$(tput sgr0)\]"

# Aliases
alias gg='git branch && git status --short'
alias ll='ls -lahF'
alias mkdir='mkdir -p'
alias vi='nvim'
alias vim='nvim'

# Path
dev=~/GitHub
for p in $dev/scripts $dev/go/bin ~/.cargo/bin; do
	[[ $PATH != *$p* && -d $p ]] && PATH=$PATH:$p
done

# History
HISTCONTROL=ignoredups:ignorespace
HISTFILESIZE=2000
HISTSIZE=1000

# Editor
export EDITOR=vim
export VISUAL=vim
export PAGER=less

# Other env vars
export CLICOLOR=true
export GREP_OPTIONS='--color=auto'
export LEDGER_FILE=$dev/finance/journal.ledger
export LESS='-MerX'
export LESSHISTFILE='-'

# Tab completion
if command -v brew &>/dev/null; then
	brew_completion=$(brew --prefix)/share/bash-completion/bash_completion
	[[ -f $brew_completion ]] && source $brew_completion
fi

# Connect to keychain
if command -v keychain &>/dev/null; then
	eval $(keychain --eval --quiet --agents ssh id_rsa)
fi
