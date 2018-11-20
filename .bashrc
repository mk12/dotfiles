# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

shopt -s checkwinsize
shopt -s histappend

if command -v exa &> /dev/null; then
	alias l=exa
	alias ll='exa -l'
	alias la='exa -la'
else
	alias l=ls
	alias ll='ls -Ghl'
	alias la='ls -Ghla'
fi

if command -v nvim &> /dev/null; then
	alias vi=nvim
	alias vim=nvim
	export EDITOR=nvim
	export VISUAL=nvim
else
	alias vi=vim
	export EDITOR=vim
	export VISUAL=vim
fi

if command -v rg &> /dev/null; then
	export FZF_DEFAULT_COMMAND='rg --files'
fi

alias gg='git branch && git status -s'

export CLICOLOR=true
export GREP_OPTIONS='--color=auto'
export HISTCONTROL=ignoredups:ignorespace
export HISTFILESIZE=2000
export HISTSIZE=1000
export LESS='-MerX'
export LESSHISTFILE='-'
export PAGER=less

export PROJECTS=~/GitHub
export LEDGER_FILE=$PROJECTS/finance/journal.ledger

for p in $PROJECTS/scripts ~/.fzf/bin ~/.cargo/bin; do
	[[ $PATH != *$p* && -d $p ]] && PATH=$PATH:$p
done
