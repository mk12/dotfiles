#!/bin/bash

set -Eeufo pipefail
trap 'echo >&2 "$0:$LINENO [$?]: $BASH_COMMAND"' ERR

usage() {
    cat <<EOF
Usage: $0 [-cyf]

Symlink dotfiles in the home directory

Options:
    -c, --clean  Also clean stale symlinks
    -y, --yes    Skip yes/no prompts
    -f, --fzf    Pick with fzf
EOF
}

clean=false
yes=false
fzf=false

while [[ $# -gt 0 ]]; do
    arg=$1; shift
    case $arg in
        -h|--help) usage; exit ;;
        -c|--clean) clean=true ;;
        -y|--yes) yes=true ;;
        -f|--fzf) fzf=true ;;
        *) usage >&2; exit 1 ;;
    esac
done

run() { echo "$*"; "$@"; }

cd "$(dirname "$0")"
script_dir=$(pwd)

if [[ "$clean" = true ]]; then
    while read -r f; do
        if [[ $(readlink "$f") == "$script_dir"* ]]; then
            [[ -e "$f" ]] || run rm "$f"
            dir=$(dirname "$f")
            [[ -n "$(ls -Aq "$dir")" ]] || run rmdir "$dir"
        fi
    done < <(
        find ~ -maxdepth 1 -name '.*' -type l;
        find ~/.config -maxdepth 4 -type l -not -path '.config/emacs/*/*'
    )
fi

while read -r f; do
    [[ "$f" != /* ]] && continue
    f=${f#/}
    [[ -f "$f" ]] && continue
    run touch "$f"
    case "$f" in
        .local.profile) echo "# shellcheck shell=sh" > "$f" ;;
    esac
done < .gitignore

available=()
while read -r f; do
    [[ "$f" != .* ]] && continue
    [[ "$f" == .gitignore ]] && continue
    f=${f#./}
    dest="$script_dir/$f"
    [[ "$(readlink ~/"$f")" == "$script_dir/$f" ]] && continue
    available+=("$f")
done < <(git ls-files -cdo -X .config/git/ignore)

if [[ "${#available[@]}" -eq 0 ]]; then
    echo "Everything is already linked"
    exit
fi

if [[ "$fzf" = true ]]; then
    while read -r f; do
        run ln -sfn "$script_dir/$f" ~/"$f"
    done < <(printf "%s\n" "${available[@]}" | fzf --multi)
    exit
fi

for f in "${available[@]}"; do
    if [[ $yes != true ]]; then
        echo -n "link ~/$f? (y/N) "
        read -r reply
        [[ "$reply" =~ ^[Yy]$ ]] || continue
    fi
    mkdir -p "$(dirname ~/"$f")"
    run ln -sfn "$script_dir/$f" ~/"$f"
done
