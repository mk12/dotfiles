#!/bin/bash

set -xeufo pipefail

if [[ "$(git status -s -uno)" != *' M .config/nvim/init.vim'* ]]; then
    exit 1
fi

git diff -- .config/nvim/init.vim > neovim.patch
sed 's#\.config/nvim/init.vim#.vimrc#g' neovim.patch > vim.patch
git apply vim.patch
rm {neo,}vim.patch
