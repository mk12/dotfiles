# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Shell options
shopt -s checkwinsize
shopt -s histappend

# Aliases
alias vi=nvim
alias vim=nvim

# Environment variables
gh=~/GitHub
export CLICOLOR=true
export EDITOR=nvim
export GREP_OPTIONS='--color=auto'
export HISTCONTROL=ignoredups:ignorespace
export HISTFILESIZE=2000
export HISTSIZE=1000
export LEDGER_FILE=$gh/finance/journal.ledger
export LESS='-MerX'
export LESSHISTFILE='-'
export PAGER=less
export VISUAL=nvim

# PATH
for p in $gh/scripts ~/.cargo/bin ~/.fzf/bin; do
	[[ $PATH != *$p* && -d $p ]] && PATH=$PATH:$p
done

# Connect to keychain
if command -v keychain &> /dev/null && ! pgrep -qx ssh-agent; then
	eval $(keychain --eval --quiet --agents ssh id_rsa)
fi
