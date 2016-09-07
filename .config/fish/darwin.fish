function upd --description "Updates homebrew packages"
	brew update
	and brew upgrade
end

function notif --description "Makes a notification via Notification Center"
	terminal-notifier -activate com.apple.Terminal -message "$argv"
end

function blog --description "Starts the Hugo server for my blog"
	cd $BLOG; and hugo server -w
end

set -x BLOG ~/icloud/blog

set -x PATH $PATH /usr/local/share/git-core/contrib/diff-highlight
