# Install fisher if it isn't already installed.
if not functions -q fisher
	set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
	curl https://git.io/fisher --create-dirs -sLo \
		$XDG_CONFIG_HOME/fish/functions/fisher.fish
	fish -c fisher
end

function upd --description "Update software"
	if command -qv brew
		echo "Updating homebrew"
		brew update; and brew upgrade
	end
	if set -q TMUX
		echo "Updating tmux"
		~/.tmux/plugins/tpm/bin/clean_plugins
		~/.tmux/plugins/tpm/bin/update_plugins all
	end
	if command -qv nvim
		echo "Updating neovim"
		command nvim +PlugUpgrade +PlugUpdate +qall
	end
	if command -qv vim
		echo "Updating vim"
		command vim +PlugUpgrade +PlugUpdate +qall
	end
end

function cleanup --description "Free up disk space"
	if command -qv brew
		echo "Cleaning homebrew"
		brew cleanup -s --force; and brew prune
	end
	if command -qv nvim
		echo "Cleaning neovim"
		command nvim +PlugClean +qall
	end
	if command -qv vim
		echo "Cleaning vim"
		command vim +PlugClean +qall
	end
end

function vim --description "Remap vim to nvim"
	command nvim $argv
end

function gg --description "Show git branches and status"
	git branch; and git status --short
end

function add_paths --description "Add to the PATH"
	for dir in $argv
		if not contains $dir $PATH; and test -d $dir
			set PATH $PATH $dir
		end
	end
end

# Environment variables
set gh ~/GitHub
set -x LEDGER_FILE $gh/finance/journal.ledger
set -x EDITOR nvim
set -x VISUAL nvim
set -x PAGER less

# PATH
add_paths $gh/scripts ~/.cargo/bin ~/.fzf/bin

# Colors
set fish_color_autosuggestion brblack
set fish_color_cancel --reverse
set fish_color_command blue
set fish_color_comment brblack
set fish_color_end magenta
set fish_color_error red
set fish_color_escape red
set fish_color_history_current --bold
set fish_color_normal normal
set fish_color_operator yellow
set fish_color_param normal
set fish_color_quote green
set fish_color_redirection cyan
set fish_color_selection white --bold --background=brblack
set fish_color_valid_path --underline
set fish_pager_color_completion normal
set fish_pager_color_description green
set fish_pager_color_prefix white --bold --underline
set fish_pager_color_progress brwhite --background=cyan

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

# Connect to keychain
if command -v keychain > /dev/null; and not pgrep -qx ssh-agent
	eval (keychain --eval --quiet --agents ssh id_rsa)
end
