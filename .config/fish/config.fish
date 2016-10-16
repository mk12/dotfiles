function fish_prompt --description "Write out the prompt"
	echo -n "$USER:"
	set_color $fish_color_cwd
	echo -n (prompt_pwd)
	set_color normal
	echo -n '> '
end

function sudo --description "Execute a command as superuser"
	if test "$argv" = !!
		eval command sudo $history[1]
	else
		command sudo $argv
	end
end

function sz --description "Calculate the size of a directory"
	du -sh $argv
end

function tm --description "Shortcut for tmux commands"
	if test (count $argv) -lt 2
		tmux ls
		return
	end
	switch $argv[1]
	case 'n'
		tmux new -s $argv[2..-1]
	case 'a'
		tmux attach -t $argv[2..-1]
	case 'k'
		tmux kill-session -t $argv[2..-1]
	case '*'
		echo tm: $argv[1]: invalid argument >&2
	end
end

function vim --description "Remap vim to nvim"
	command nvim $argv
end

function gg --description "Show git branches and status"
	git branch; and git status --short
end

function be --description "Shortcut for bundle exec"
	bundle exec $argv
end

# Environment variables
set gh ~/GitHub
set -x PRO_BASE $gh
set -x GOPATH $gh/go
set -x LEDGER_FILE $gh/finance/journal.ledger
set -x EDITOR nvim
set -x VISUAL nvim
set -x PAGER less

# PATH
set paths $gh/scripts $GOPATH/bin ~/.fzf/bin
for dir in $paths
	if not contains $dir $PATH; and test -d $dir
		set PATH $PATH $dir
	end
end

# OS-specific configuration
set specific ~/.config/fish/(uname -s | tr '[A-Z]' '[a-z]').fish
if test -e $specific
	source $specific
end

# Secret information
set secret ~/.config/fish/secret.fish
if test -e $secret
	source $secret
end
