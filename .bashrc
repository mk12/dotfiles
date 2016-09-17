# If not running interactively, don't do anything.
case $- in
	*i*) ;;
	*) return;;
esac

# Vi command-line editing
set -o vi

# Bash variables
PS1='λ:\W \$ '
HISTTIMEFORMAT='%b %d %I:%M %p '
HISTCONTROL=ignoreboth
HISTIGNORE=history:pwd:exit:df:ls:ll
HISTSIZE=1000
HISTFILESIZE=2000

# Shell options
shopt -s histappend
shopt -s checkwinsize

# Shortcuts
alias ll='ls -lahF'
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
alias dump='gobjdump -d -M intel -s'
alias ccd='clang -Weverything -g -pedantic -Wno-padded -std=c11'
alias ccr='clang -Weverything -DNDEBUG -pedantic -Wno-padded -std=c11 -Os'
alias rc='rustc -C prefer-dynamic -O'
alias rt='rustc -C prefer-dynamic -O --test'
alias jun='ipython3 notebook --profile julia'
alias sucontext='. /usr/local/Cellar/context/latest/tex/setuptex'
alias blog='cd "$BLOGPATH"; hugo server -w'

# Tab completion
brew_completion=$(brew --prefix)/etc/bash_completion
[[ -f $brew_completion ]] && source $brew_completion

# Environment variables
export EDITOR=vim
export CLICOLOR=true
export LESS='-MerX'
export LESSHISTFILE='-'
export GREP_OPTIONS='--color=auto'
export MAC_USE_CURRENT_SDK=true
export HOMEBREW_CC=clang
export BLOGPATH=$HOME/icloud/blog

# Path
dev=$HOME/GitHub
CABAL_BIN=$HOME/.cabal/bin
GOROOT=$(go env GOROOT)
export GOPATH=$dev/go
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_05.jdk/Contents/Home
export PATH=$PATH:$CABAL_BIN:$dev/scripts:$GOPATH/bin:$GOROOT/bin
