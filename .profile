export PROJECTS=~/Projects

set_path() {
    # Note: These paths are ordered from lowest to highest precedence.
    set -- \
        /opt/homebrew \
        "$HOME/.fzf" \
        "$HOME/.go" \
        "$HOME/.cargo" \
        "$HOME/.local"
    for p in "$@"; do
        for vd in PATH:sbin PATH:bin MANPATH:share/man INFOPATH:share/info; do
            var=${vd%:*}
            dir=$p/${vd#*:}
            eval "val=\$$var"
            case $val in
                *"$dir"*) ;;
                *) [ -d "$dir" ] && eval "$var=\$dir:\$$var" ;;
            esac
        done
    done
    unset p vd var dir val
}

set_path
unset -f set_path

if [ -d /opt/homebrew ]; then
    export HOMEBREW_PREFIX=/opt/homebrew
    export HOMEBREW_SHELLENV_PREFIX=/opt/homebrew
    export HOMEBREW_REPOSITORY=/opt/homebrew
    export HOMEBREW_CELLAR=/opt/homebrew/Cellar
fi

export GOPATH=$HOME/.go

export LEDGER_FILE=$PROJECTS/finance/journal.ledger
export LEDGER_PRICE_DB=$PROJECTS/finance/pricedb

export CLICOLOR=true
export PAGER=less
export LESS=-FQRXi

export BAT_THEME=base16

export FZF_DEFAULT_OPTS="--history=$HOME/.fzf/history \
--color=bg+:10,bg:0,fg+:13,fg:12,header:4,hl+:4,hl:4,info:3,marker:6,pointer:6,\
prompt:3,spinner:6"

export COQ_COLORS="constr.evar=37:constr.keyword=1:constr.notation=37:\
constr.path=95:constr.reference=32:constr.type=33:message.debug=35;1:\
message.error=31;1:message.warning=33;1:module.definition=91;1:\
module.keyword=1:tactic.keyword=1:tactic.primitive=32:tactic.string=91"

if command -v fd > /dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type file'
elif command -v rg > /dev/null 2>&2; then
    export FZF_DEFAULT_COMMAND='rg --files'
else
    export FZF_DEFAULT_COMMAND=''
fi
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

if command -v nvim > /dev/null 2>&1; then
    export EDITOR=nvim
    export VISUAL=nvim
else
    export EDITOR=vim
    export VISUAL=vim
fi

. ~/.profile.local
