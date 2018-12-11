# Install fisher if it isn't already installed.
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo \
        $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# =========== Functions ========================================================

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
        brew cleanup -s; and brew prune
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

function add_paths --description "Add to the PATH"
    for dir in $argv
        if begin; not contains $dir $PATH; and test -d $dir; end
            set PATH $PATH $dir
        end
    end
end

function open_editor --description "Open the EDITOR"
    if test (count $argv) -eq 0 -a -f Session.vim
        env $EDITOR -S Session.vim
    else
        env $EDITOR $argv
    end
end

# =========== Aliases ==========================================================

alias vi open_editor
alias vim open_editor
alias nvim open_editor

alias gg "git branch; and git status -s"

if command -qv exa
    alias l "exa"
    alias ll "exa -l"
    alias la "exa -la"
else
    alias l "ls"
end

# =========== Variables ========================================================

set -x PAGER less

if command -qv nvim
    set -x EDITOR nvim
    set -x VISUAL nvim
else
    set -x EDITOR vim
    set -x VISUAL vim
end

if command -qv rg
    set -x FZF_DEFAULT_COMMAND "rg --files"
end

# =========== Colors ===========================================================

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

# =========== Other config =====================================================

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

# =========== Epilogue =========================================================

# Do this last so that other config can override PROJECTS.
if test -z $PROJECTS
    set -x PROJECTS ~/GitHub
end

set -x LEDGER_FILE $PROJECTS/finance/journal.ledger

add_paths $PROJECTS/scripts ~/.fzf/bin ~/.cargo/bin
