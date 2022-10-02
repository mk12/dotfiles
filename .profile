# shellcheck shell=sh

# =========== PATH =============================================================

add_paths() {
    var=$1; shift
    dirs=$1; shift
    new=:
    saved_ifs=$IFS
    IFS=:
    for prefix; do
        for dir in $dirs; do
            [ -d "$prefix/$dir" ] && new=$new$prefix/$dir:
        done
    done
    eval "old=\$$var"
    # shellcheck disable=SC2154
    for dir in $old; do
        case $new in
            *:$dir:*) ;;
            *) new=$new$dir: ;;
        esac
    done
    IFS=$saved_ifs
    new=${new#:}
    new=${new%:}
    eval "export $var=\$new"
    unset var dirs new saved_ifs prefix dir old
}

add_paths PATH bin:sbin ~/.local ~/.cargo ~/.go /opt/homebrew
add_paths CPATH include ~/.local /opt/homebrew
add_paths LIBRARY_PATH lib ~/.local /opt/homebrew

unset -f add_paths

# =========== Short variables ==================================================

export BAT_THEME=base16-256
export CLICOLOR=true
export DENO_FUTURE_CHECK=1
export GOPATH=~/.go
export LESS=-FQRXi
export LS_COLORS=
export PAGER=less

# =========== Long variables ===================================================

export COQ_COLORS="constr.evar=37:constr.keyword=1:constr.notation=37:\
constr.path=38;5;21:constr.reference=32:constr.type=33:message.debug=35;1:\
message.error=31;1:message.warning=33;1:module.definition=1;38;5;16:\
module.keyword=1:tactic.keyword=1:tactic.primitive=32:tactic.string=38;5;16"

export FZF_DEFAULT_OPTS="--history=$HOME/.local/state/fzf/history \
--height=95% --layout=reverse --info=inline --border \
--bind='alt-<:first,alt->:last,alt-p:toggle-preview,ctrl-f:preview-page-down,\
ctrl-b:preview-page-up,alt-/:change-preview-window(right),\
alt--:change-preview-window(bottom)' \
--color=bg+:18,bg:0,fg+:21,fg:20,header:4,hl+:4,hl:4,info:3,marker:6,pointer:6,\
prompt:3,spinner:6"

# =========== Logic variables ==================================================

if command -v fd > /dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND="fd --type file --strip-cwd-prefix"
elif command -v rg > /dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND="rg --files"
fi

if command -v nvim > /dev/null 2>&1; then
    export EDITOR=nvim
    export VISUAL=nvim
else
    export EDITOR=vim
    export VISUAL=vim
fi

# =========== Local config =====================================================

# shellcheck source=.local.profile
. ~/.local.profile

if [ -z "$PROJECTS" ]; then
    # shellcheck disable=SC3028
    echo "${BASH_SOURCE:-$0}: PROJECTS is unset!" >&2
fi
