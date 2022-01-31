#!/bin/bash

set -eufo pipefail

# Options
clean=false
yes=false

# Globals
script_dir=

die() {
    echo "$0: $*"
    exit 1
}

run() {
    echo "$*"
    "$@"
}

usage() {
    cat <<EOS
Usage: $0 [-hcy]

Symlink dotfiles in the home directory.

Options:
    -h  Show this help message
    -c  Also clean stale symlinks
    -y  Skip yes/no prompts
EOS
}

main() {
    cd "$(dirname "$0")"
    script_dir=$(pwd)
    link_dotfiles
    if [[ $clean == true ]]; then
        clean_dotfiles
    fi
}

link_dotfiles() {
    while read -r f; do
        [[ "$f" != /* ]] && continue
        f=${f#/}
        [[ -f "$f" ]] && continue
        run touch "$f"
        case "$f" in
            .local.profile) echo "# shellcheck shell=sh" > "$f" ;;
        esac
    done < .gitignore

    while read -r f; do
        [[ "$f" != .* ]] && continue
        [[ "$f" == .gitignore ]] && continue
        f=${f#./}
        dest="$script_dir/$f"
        [[ "$(readlink ~/"$f")" == "$dest" ]] && continue
        if [[ $yes != true ]]; then
            echo -n "link ~/$f? (y/N) "
            read -r reply < /dev/tty
            [[ "$reply" =~ ^[Yy]$ ]] || continue
        fi
        mkdir -p "$(dirname ~/"$f")"
        run ln -sf "$dest" ~/"$f"
    done < <(git ls-files -cdo -X .config/git/ignore)
}

clean_dotfiles() {
    while read -r f; do
        [[ $(readlink "$f") == "$script_dir"* ]] || continue
        [[ -e "$f" ]] || run rm "$f"
        dir=$(dirname "$f")
        [[ -n "$(ls -Aq "$dir")" ]] || run rmdir "$dir"
    done < <(
        find ~ -maxdepth 1 -name '.*' -not -name .Trash \
            -exec find {} -maxdepth 3 -type l \;;
        find ~/.config -type l
    )
}

while getopts "hcy" opt; do
    case $opt in
        h) usage; exit 0 ;;
        c) clean=true ;;
        y) yes=true ;;
        *) exit 1 ;;
    esac
done

main
