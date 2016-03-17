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
	cd ~/icloud/blog
	and hugo server -w
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
function sucontext --description "Sets up the ConTeXt root"
	echo "TODO: implement this function"
end

# Environment variables
set dev ~/Development
set -x GOPATH $dev/go
set -x VAGRANT_CWD $dev/vagrant
set -x EDITOR vim
set -x LEDGER_FILE ~/icloud/finance/journal.ledger
set -x PRO_BASE $dev

# Path
set PATH $PATH $dev/scripts $GOPATH/bin ~/.cabal/bin

# This file is for secret information.
source ~/.config/fish/secret.fish
