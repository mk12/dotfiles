#!/usr/bin/env bash

function link_dotfiles {
	# Get the script's path
	src="${BASH_SOURCE[0]}"
	dir=$(dirname "$src")
	while [ -L "$src" ]; do
		src=$(readlink "$src")
		[[ $src != /* ]] && src="$dir/$src"
		dir=$(cd -P "$( dirname "$src")" && pwd)
	done
	dir=$(cd -P "$( dirname "$src")" && pwd)

	# Symlink the dotfiles with relative links
	relbase=$(python -c "import os.path; print os.path.relpath('$dir','$HOME')")
	for filepath in $(find "$dir" -mindepth 1 -maxdepth 1 \! -name ".git" \! -name ".DS_Store" \! -name "*.md" \! -name "$(basename "$src")"); do
		file=$(basename $filepath)
		if [[ -e ~/$file ]]; then
			echo "~/$file: File exists"
		else
			ln -s $relbase/$file ~/$file > /dev/null
			echo "Symlinked ~/$file"
		fi
	done

	# Clone Vundle and install bundles
	if [[ ! -d "$HOME/.vim/bundle/vundle" ]]; then
		mkdir -p ~/.vim/bundle
		git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
		vim -c 'BundleInstall' -c 'q|q'
	fi
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
