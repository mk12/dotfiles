# Shell prompt
export PS1='\s:\W \$ '

# Vi command-line editing
set -o vi

# Shortcuts
alias ll='ls -lah'
alias mv='mv -i'
alias cp='cp -i'
alias df='df -h'
alias du='du -h'
alias mkdir='mkdir -p'
alias sz='du -sh'
alias vi='vim'
alias vim='mvim -v'
alias upd='brew update && brew upgrade'
alias notif='terminal-notifier -activate com.apple.Terminal -message'
alias ccd='clang -Weverything -g -pedantic -std=c99'
alias ccr='clang -Weverything -DNDEBUG -pedantic -std=c99 -Os'
alias dump='gobjdump -d -M intel -s'

# Tab completion
brew_completion=$(brew --prefix)/etc/bash_completion
[[ -f $brew_completion ]] && source $brew_completion

# Environment variables
export EDITOR=vim
export HISTTIMEFORMAT='%b %d %I:%M %p '
export HISTCONTROL=ignorespace
export HISTIGNORE=history:pwd:exit:df:ls:ll
export CLICOLOR=true
export LESS='-MerX'
export LESSHISTFILE='-'
export GREP_OPTIONS='--color=auto'
export MAC_USE_CURRENT_SDK=true
export HOMEBREW_CC=clang
export GOPATH=$HOME/Development/go
export PATH=$PATH:$HOME/bin
