# Shell prompt
# export PS1='\s:\W \$ '
export PS1='λ:\W \$ '

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
export HISTTIMEFORMAT='%b %d %I:%M %p '
export HISTCONTROL=ignorespace
export HISTIGNORE=history:pwd:exit:df:ls:ll
export CLICOLOR=true
export LESS='-MerX'
export LESSHISTFILE='-'
export GREP_OPTIONS='--color=auto'
export MAC_USE_CURRENT_SDK=true
export HOMEBREW_CC=clang
export BLOGPATH=$HOME/icloud/blog
export VAGRANT_CWD=$HOME/Development/vagrant

dev=$HOME/Development
CABAL_BIN=$HOME/.cabal/bin
SCRIPTS_BIN=$dev/scripts:$dev/web/mark/scripts
GOROOT=$(go env GOROOT)
export GOPATH=$HOME/Development/go
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_05.jdk/Contents/Home
export PATH=$PATH:$CABAL_BIN:$SCRIPTS_BIN:$GOPATH/bin:$GOROOT/bin
