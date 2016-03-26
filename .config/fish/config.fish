# Set the prompt.
function fish_prompt --description "Write out the prompt"
	echo -n "$USER:"
	set_color $fish_color_cwd
	echo -n (prompt_pwd)
	set_color normal
	echo -n '> '
end

# Shortcuts
function sz --description "Calculate the size of a directory"
	du -sh $argv
end
function upd --description "Updates homebrew packages"
	brew update
	and brew upgrade
end
function blog --description "Starts the Hugo server for my blog"
	cd $BLOG; and hugo server -w
end
function notif --description "Makes a notification via Notification Center"
	terminal-notifier -activate com.apple.Terminal -message "$argv"
end
function be --description "Shortcut for bundle exec"
	bundle exec $argv
end
function gg --description "Show git branches and status"
	git branch; and git status --short
end

# Environment variables
set gh ~/GitHub
set -x PRO_BASE $gh
set -x GOPATH $gh/go
set -x LEDGER_FILE $gh/finance/ledger.journal
set -x EDITOR vim
set -x VISUAL vim
set -x PAGER less
set -x BLOG ~/icloud/blog

# Path
set PATH $PATH $gh/scripts $GOPATH/bin ~/.cabal/bin

# This file is for secret information.
source ~/.config/fish/secret.fish
