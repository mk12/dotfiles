# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# For Emacs.
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# Path
GH=~/GitHub
for p in $GH/scripts $GH/go/bin ~/.cargo/bin; do
  [[ $PATH != *$p* && -d $p ]] && PATH=$PATH:$p
done

# Prompt
setopt promptsubst
PROMPT='$ret_status%f%b %F{green}%c%f '

# Other env vars
export LANG=en_US.UTF-8
export LEDGER_FILE=$GH/finance/journal.ledger

# Aliases
alias gg='git branch && git status --short'
alias vi='nvim'
alias vim='nvim'

# Connect to keychain
if command -v keychain &>/dev/null; then
  eval $(SHELL=zsh keychain --eval --quiet --agents ssh id_rsa)
fi

# Tab completion
function {
  local p='/usr/local/share/zsh-completions'
  [[ -d $p ]] && fpath=($p $fpath)
}

# Secret config
function {
    local f=~/.zshrc_secret
    [[ -f "$f" ]] && source "$f"
}
