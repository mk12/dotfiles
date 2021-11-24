#!/bin/bash

set -eufo pipefail

# These are not checked into the dotfiles repository, but I still want them in
# the repository directory and symlinked so that everything is together.
readonly local_files=(
    ".config/fish/local.fish"
    ".config/git/local.gitconfig"
    ".config/hammerspoon/local.lua"
    ".config/kitty/colors.conf"
    ".config/kitty/remotes"
    ".config/tmux/local.conf"
    ".local.profile"
)

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
usage: $0 [-hcy]

Symlink dotfiles in the home directory.

Options:
    -h  show this help message
    -c  also clean stale symlinks
    -y  skip yes/no prompts
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
    # Create local files and ignore them in the repo.
    exclude=".git/info/exclude"
    for f in "${local_files[@]}"; do
        if ! [[ -f "$f" ]]; then
            run touch "$f"
            [[ "$f" == .profile.local ]] && echo "# shellcheck shell=sh" > "$f"
        fi
        if ! grep -qxF "/$f" "$exclude"; then
            echo "/$f" >> "$exclude"
        fi
    done

    # Symlink dotfiles.
    while read -r f; do
        f=${f#./}
        # Skip if it's ignored by .gitignore (not by .git/info/exclude).
        if git check-ignore -v "$f" | awk -F: '$1 ~ /exclude$/ { exit 1 }'; then
            continue
        fi
        if [[ $yes != true ]]; then
            echo -n "link ~/$f? (y/N) "
            read -r reply
            [[ "$reply" =~ ^[Yy]$ ]] || continue
        fi
        mkdir -p "$(dirname ~/"$f")"
        dest="$script_dir/$f"
        say=
        [[ "$(readlink ~/"$f")" != "$dest" ]] && say=run
        $say ln -sf "$dest" ~/"$f"
    done < <(find . -type f -path './.*' -not -path './.git/*')
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
