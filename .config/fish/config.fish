function fish_prompt --description "Write out the prompt"
	echo -n "$USER:"
	set_color $fish_color_cwd
	echo -n (prompt_pwd)
	set_color normal
	echo -n "> "
end

function inform --description "Writes a pretty message"
	set_color purple
	echo $argv...
	set_color normal
end

function upd --description "Updates homebrew, tmux, and neovim"
	if command -qv brew
		inform "Updating homebrew"
		brew update; and brew upgrade
	end
	if set -q TMUX
		inform "Updating tmux"
		~/.tmux/plugins/tpm/bin/clean_plugins
		~/.tmux/plugins/tpm/bin/update_plugins all
	end
	if command -qv nvim
		inform "Updating neovim"
		command nvim +PlugUpgrade +PlugUpdate +qall
	end
	if command -qv vim
		inform "Updating vim"
		command vim +PlugUpgrade +PlugUpdate +qall
	end
end

function cleanup --description "Frees up disk space"
	if command -qv brew
		inform "Cleaning homebrew"
		brew cleanup -S --force; and brew prune
	end
	if command -qv nvim
		inform "Cleaning neovim"
		command nvim +PlugClean +qall
	end
	if command -qv vim
		inform "Cleaning vim"
		command vim +PlugClean +qall
	end
end

function tm --description "Shortcut for tmux commands"
	# Start the server if it's not running (tmux-continuum will auto-restore).
	if not tmux ls > /dev/null ^&1
		tmux new-session -d -s _start
		tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh
		tmux kill-session -t _start
	end
	if test (count $argv) -lt 2
		tmux ls
		return
	end
	switch $argv[1]
	case 'n' 'N'
		tmux new -s $argv[2..-1]
	case 'a' 'A'
		tmux attach -t $argv[2..-1]
	case 'k' 'K'
		tmux kill-session -t $argv[2..-1]
	case '*'
		echo "tm: $argv[1]: invalid argument" >&2
		return 1
	end
end

function vim --description "Remap vim to nvim"
	command nvim $argv
end

function gg --description "Show git branches and status"
	git branch; and git status --short
end

function fzf --description "Invokes FZF with proper color"
	if test -f ~/.solarized_light
		command ~/.fzf/bin/fzf --color=fg+:0,bg+:7
	else
		command ~/.fzf/bin/fzf --color=fg+:7,bg+:0
	end
end

function be --description "Shortcut for bundle exec"
	bundle exec $argv
end

function sz --description "Calculate the size of a directory"
	du -sh $argv
end

function sudo --description "Execute a command as superuser"
	if test "$argv" = !!
		eval command sudo $history[1]
	else
		command sudo $argv
	end
end

function add_paths --description "Adds to the PATH variable"
	for dir in $argv
		if not contains $dir $PATH; and test -d $dir
			set PATH $PATH $dir
		end
	end
end

# Environment variables
set gh ~/GitHub
set -x PRO_BASE $gh
set -x GOPATH $gh/go
set -x LEDGER_FILE $gh/finance/journal.ledger
set -x EDITOR nvim
set -x VISUAL nvim
set -x PAGER less
set -x FZF_DEFAULT_OPTS "--no-bold \
	--color=16,fg:-1,bg:-1,hl:4,hl+:4,info:2,prompt:4,pointer:9"

# PATH
add_paths $gh/scripts $GOPATH/bin ~/.cargo/bin

# OS-specific configuration
set specific ~/.config/fish/(uname -s | tr "[A-Z]" "[a-z]").fish
if test -e $specific
	source $specific
end

# Secret information
set secret ~/.config/fish/secret.fish
if test -e $secret
	source $secret
end
