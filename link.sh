#!/usr/bin/env bash

link_dotfiles() {
    # Get the script's path
    src="${BASH_SOURCE[0]}"
    dir=$(dirname "$src")
    while [ -L "$src" ]; do
        src=$(readlink "$src")
        [[ $src != /* ]] && src="$dir/$src"
        dir=$(cd -P "$( dirname "$src")" && pwd)
    done
    dir=$(cd -P "$( dirname "$src")" && pwd)

    mkdir -p "$HOME"/.config/{fish,nvim}

    cd -P "$dir"
    for filepath in $(find . -type f -path "./.*" \
            -not -name ".DS_Store" \
            -not -path "./.git/*" \
            -not -path "./.config/fish/.gitignore"); do
        file=${filepath#'./'}
        if [[ -e ~/$file ]]; then
            echo "~/$file: file exists"
        else
            echo "symlinking ~/$file -> $dir/$file"
            ln -s "$dir/$file" "$HOME/$file" > /dev/null
        fi
    done
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    link_dotfiles
else
    read -p "Symlink all dotfiles into your home directory? (Y/n) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        link_dotfiles
    else
        exit 1
    fi
fi
