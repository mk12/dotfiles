export PROJECTS=~/Projects

set_path() {
    set -- \
        "$HOME/bin" \
        "$HOME/brew/bin" \
        "$HOME/.linuxbrew/bin" \
        "$HOME/.fzf/bin" \
        "$HOME/.cargo/bin" \
        "$HOME/.ghcup/bin" \
        "$HOME/.cabal/bin" \
        "$PROJECTS/scripts"
    for p in "$@"; do
        case $PATH in
            *"$p"*) ;;
            *) [ -d "$p" ] && PATH=$PATH:$p ;;
        esac
    done
}

set_path
unset -f set_path

export GOPATH=$PROJECTS/go

export LEDGER_FILE=$PROJECTS/finance/journal.ledger

export CLICOLOR=true
export PAGER=less
export LESS=-FQRXi

export BAT_THEME=base16

export FZF_DEFAULT_OPTS="--history=$HOME/.fzf/history \
--preview-window=top:50% \
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
