function upd --description "Updates homebrew packages"
	brew update
	and brew upgrade
end

function dump --description "Dissassemble to Intel syntax"
	gobjdump -d -M intel -s $argv
end

function notif --description "Makes a notification via Notification Center"
	terminal-notifier -activate com.apple.Terminal -message "$argv"
end

function blog --description "Starts the Hugo server for my blog"
	cd $BLOG; and hugo server -w
end

set -x BLOG ~/icloud/blog
