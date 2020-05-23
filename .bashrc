source ~/.profile

[[ $- != *i* ]] && return

shopt -s checkwinsize
shopt -s histappend

HISTCONTROL=ignoreboth
HISTFILESIZE=20000
HISTSIZE=10000
