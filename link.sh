#!/bin/bash

set -eufo pipefail

prog=$(basename "$0")

force=false

die() {
    echo "$prog: $*"
    exit 1
}

usage() {
    cat <<EOS
usage: $prog [-fh]

symlink dotfiles in the home directory

options:
    -f  skip prompts
    -h  show this help message
EOS
}

link_dotfiles() {
    src="$0"
    dir=$(dirname "$src")
    while [[ -L "$src" ]]; do
        src=$(readlink "$src")
        [[ $src != /* ]] && src="$dir/$src"
        dir=$(cd -P "$(dirname "$src")" && pwd)
    done
    dir=$(cd -P "$(dirname "$src")" && pwd)

    cd -P "$dir" || die "failed to cd to $dir"

    while read -r d; do
        mkdir -p "$HOME/.config/$d"
    done < <(ls -1 .config/)
    mkdir -p "$HOME/.lein"

    files=()
    while read -r filepath; do
        file=${filepath#'./'}
        if [[ -e "$HOME/$file" ]]; then
            echo "$HOME/$file: file exists"
        else
            files+=("$file")
        fi
    done < <(find . -type f -path "./.*" \
            -not -name ".DS_Store" \
            -not -path "./.git/*" \
            -not -path "./.config/fish/.gitignore")

    for file in "${files[@]+"${files[@]}"}"; do
        echo -n "symlink $HOME/$file -> $dir/$file ? (y/N) " reply
        read -r reply
        if [[ "$reply" =~ ^[Yy]$ ]]; then
            ln -s "$dir/$file" "$HOME/$file" > /dev/null
            echo "symlinked $HOME/$file -> $dir/$file"
        else
            echo "skipping $file"
        fi
    done
}

main() {
    if [[ "$force" == true ]]; then
        link_dotfiles
    else
        echo -n "Symlink dotfiles into your home directory? (y/N) "
        read -r reply
        if [[ "$reply" =~ ^[Yy]$ ]]; then
            link_dotfiles
        else
            die "aborting"
        fi
    fi
}

while getopts "fh" opt; do
    case $opt in
        f) force=true ;;
        h) usage; exit 0 ;;
        *) exit 1 ;;
    esac
done
shift $((OPTIND - 1))
[[ $# -eq 0 ]] || die "too many arguments"

main
