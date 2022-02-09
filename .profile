# shellcheck shell=sh

# =========== PATH =============================================================

set_path() {
    path=:
    for prefix in "$@"; do
        for dir in "$prefix/bin" "$prefix/sbin" "$prefix/shims"; do
            [ -d "$dir" ] && path=$path$dir:
        done
    done
    saved_ifs=$IFS
    IFS=:
    for dir in $PATH; do
        case $path in
            *:$dir:*) ;;
            *) path=$path$dir:
        esac
    done
    IFS=$saved_ifs
    path=${path#:}
    path=${path%:}
    export PATH="$path"
    unset path prefix saved_ifs dir
}

set_path ~/.asdf ~/.local ~/.cargo ~/.go /opt/homebrew
unset -f set_path

# =========== Short variables ==================================================

export ASDF_CONFIG_FILE=~/.config/asdf/asdfrc
export BAT_THEME=base16
export CLICOLOR=true
export GOPATH=~/.go
export LESS=-FQRXi
export LS_COLORS=
export PAGER=less

# =========== Long variables ===================================================

export COQ_COLORS="constr.evar=37:constr.keyword=1:constr.notation=37:\
constr.path=95:constr.reference=32:constr.type=33:message.debug=35;1:\
message.error=31;1:message.warning=33;1:module.definition=91;1:\
module.keyword=1:tactic.keyword=1:tactic.primitive=32:tactic.string=91"

export FZF_DEFAULT_OPTS="--history=$HOME/.local/state/fzf/history \
--height=95% --layout=reverse --info=inline --border \
--bind='alt-<:first,alt->:last,alt-p:toggle-preview,\
alt-/:change-preview-window(right),alt--:change-preview-window(bottom)' \
--color=bg+:10,bg:0,fg+:13,fg:12,header:4,hl+:4,hl:4,info:3,marker:6,pointer:6,\
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
