#!/bin/bash

set -xeufo pipefail

if [[ "$(git status -s uno)" != 'M  .config/nvim/init.vim' ]]; then
    exit 1
fi

git diff -- .config/nvim/init.vim > v.patch
sed -i '' 's#\.config/nvim/init.vim#.vimrc#g' v.patch
git apply v.patch
rm v.patch
