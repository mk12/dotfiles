# Set the prompt.
function fish_prompt --description "Write out the prompt"
		echo -n "$USER:"
		set_color $fish_color_cwd
		echo -ns (prompt_pwd)
		set_color normal
		echo -ns '> '
end

# Shortcuts
function sz --description "Calculate the size of a directory"
		command du -sh $argv
end
function upd --description "Updates homebrew packages"
		command brew update
		and command brew upgrade
end
function blog --description "Starts the Hugo server for my blog"
		cd ~/icloud/blog
		and command hugo server -w
end
function notif --description "Makes a notification via Notification Center"
		command terminal-notifier -activate com.apple.Terminal -message "$argv"
end
function sucontext --description "Sets up the ConTeXt root"
		echo "TODO: implement this function"
end

# Environment variables
set dev ~/Development
set go_root (command go env GOROOT)
set -x GOPATH $dev/go
set -x VAGRANT_CWD $dev/vagrant
set -x EDITOR vim

# Path
set PATH $PATH $dev/scripts $GOPATH/bin $go_root/bin ~/.cabal/bin
