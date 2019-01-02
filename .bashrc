# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

shopt -s checkwinsize
shopt -s histappend

HISTCONTROL=ignoreboth
HISTFILESIZE=20000
HISTSIZE=10000

source ~/.shellrc
