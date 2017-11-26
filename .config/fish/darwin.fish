function dump --description "Dissassemble to Intel syntax"
	gobjdump -d -M intel -s $argv
end

function notif --description "Send to Notification Center"
	terminal-notifier -activate com.apple.Terminal -message "$argv"
end

function blog --description "Start the Hugo server"
	cd $BLOG
	and hugo server -w
end

set -x BLOG ~/Dropbox/blog

add_paths \
	/usr/local/opt/git/share/git-core/contrib/diff-highlight \
	/Library/TeX/texbin
