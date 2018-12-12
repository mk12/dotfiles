# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

shopt -s checkwinsize
shopt -s histappend

open_editor() {
    if [[ $# -eq 0 && -f Session.vim ]]; then
        env $EDITOR -S Session.vim
    else
        env $EDITOR "$@"
    fi
}

alias vi=open_editor
alias vim=open_editor
alias nvim=open_editor

alias gg='git branch && git status -s'

if command -v exa &> /dev/null; then
    alias l=exa
    alias ll='exa -l'
    alias la='exa -la'
else
    alias l=ls
fi

export CLICOLOR=true
export GREP_OPTIONS='--color=auto'
export HISTCONTROL=ignoredups:ignorespace
export HISTFILESIZE=2000
export HISTSIZE=1000
export LESS='-MerX'
export LESSHISTFILE='-'
export PAGER=less

export FZF_DEFAULT_OPTS="--color=bg+:10,bg:0,fg+:13,fg:12,header:4,hl+:4,hl:4,\
info:3,marker:6,pointer:6,prompt:3,spinner:6"

if command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files'
fi

if command -v nvim &> /dev/null; then
    export EDITOR=nvim
    export VISUAL=nvim
else
    export EDITOR=vim
    export VISUAL=vim
fi

export PROJECTS=~/GitHub
export LEDGER_FILE=$PROJECTS/finance/journal.ledger
for p in $PROJECTS/scripts ~/.fzf/bin ~/.cargo/bin; do
    [[ $PATH != *$p* && -d $p ]] && PATH=$PATH:$p
done
