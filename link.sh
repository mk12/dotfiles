#!/bin/bash

set -eufo pipefail

readonly prog=$(basename "$0")

readonly local_files=(
    ".profile.local"
    ".config/fish/local.fish"
    ".config/kitty/colors.conf"
    ".config/kitty/remotes"
)

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

touch_local_files() {
    exclude=".git/info/exclude"
    for file in "${local_files[@]}"; do
        echo "touch ./$file"
        touch "./$file"
        if ! grep -qxF "/$file" "$exclude"; then
            echo "adding /$file to $exclude"
            echo "/$file" >> "$exclude"
        fi
    done
}

link_file() {
    dir=$1
    file=$2
    mkdir -p "$(dirname "$HOME/$file")"
    ln -s "$dir/$file" "$HOME/$file" > /dev/null
    echo "symlinked $HOME/$file -> $dir/$file"
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

    touch_local_files

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
            -not -path "./.git/*")

    for file in "${files[@]+"${files[@]}"}"; do
        if [[ "$force" == true ]]; then
            link_file "$dir" "$file"
            continue
        fi

        echo -n "symlink $HOME/$file -> $dir/$file ? (y/N) "
        read -r reply
        if [[ "$reply" =~ ^[Yy]$ ]]; then
            link_file "$dir" "$file"
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
