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
alias notif='/Applications/Terminal\ Notifier.app/Contents/MacOS/terminal-notifier -activate com.apple.Terminal -message'

# Development
alias ccd='clang -Weverything -g -pedantic -std=c99'
alias ccr='clang -Weverything -DNDEBUG -pedantic -std=c99 -Os'
alias dump='gobjdump -d -M intel -s'

# Tab completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
fi

# Bash history
export HISTTIMEFORMAT='%b %d %I:%M %p '
export HISTCONTROL=ignorespace
export HISTIGNORE="history:pwd:exit:df:ls:ll"

# Environment variables
export CLICOLOR=true
export LESS='-MerX'
export LESSHISTFILE='-'
export GREP_OPTIONS='--color=auto'
export MAC_USE_CURRENT_SDK=true
export HOMEBREW_CC='clang'

# Encryption
function aes256 {
    if [[ -z "$1" ]]; then
        echo "usage: $FUNCNAME file"
    elif [[ -f "$1" ]]; then
        openssl aes-256-cbc -e -a -in "$1" -out "$1".aes
    else
        echo "$FUNCNAME: $1: No such file"
    fi
}

# Decryption
function aes256d {
    if [[ -z "$1" ]]; then
        echo "usage: $FUNCNAME file"
    elif [[ -f "$1" ]]; then
        if [[ "${1##*.}" == "aes" ]]; then
            openssl aes-256-cbc -d -a -in "$1" -out "${1%.aes}"
        else
            echo "$FUNCNAME: $1: Does not have AES extension"
        fi
    else
        echo "$FUNCNAME: $1: No such file"
    fi
}
