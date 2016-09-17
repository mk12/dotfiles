function fish_prompt --description "Write out the prompt"
	echo -n "$USER:"
	set_color $fish_color_cwd
	echo -n (prompt_pwd)
	set_color normal
	echo -n '> '
end

function sz --description "Calculate the size of a directory"
	du -sh $argv
end

function tm --description "Shortcut for tmux commands"
	if [ (count $argv) -lt 2 ]
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
set -x EDITOR vim
set -x VISUAL vim
set -x PAGER less

# PATH
set paths $gh/scripts $GOPATH/bin ~/.fzf/bin ~/.cabal/bin
for dir in $paths
	if test -d $dir
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
