# If not running interactively, don't do anything.
if not status --is-interactive
    exit
end

# =========== Plugins ==========================================================

# Install fisher if it isn't already installed.
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo \
        $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# =========== Shared config ====================================================

# Source configuration shared with bashrc. Only do it for login shells since
# other shells will inherit the environment variables (and bass is slow).
if status --is-login
    if functions -q bass
        bass source ~/.shellrc
    else
        echo (status -f): "bass unavailable, not sourcing shellrc"
    end
end

# =========== Aliases ==========================================================

alias g=git
alias gg='git status; and git branch'
alias vi=$EDITOR
alias vim=$EDITOR

if command -qv exa
    alias l=exa
    alias ll='exa -l'
    alias la='exa -la'
end

# =========== Functions ========================================================

function bbundle --description "Use brew bundle with a combined Brewfile"
    if ! command -qv brew
        echo "Homebrew not installed" >&2
        return 1
    end
    set combined (mktemp)
    cat ~/.Brewfile{,.local} > $combined
    brew bundle $argv --file=$combined
    rm $combined
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
        echo "Checking ~/.Brewfile{,.local} to see what to uninstall"
        bbundle cleanup
        read -l -P 'Proceed? [y/N] ' answer
        if test $answer != y -a $answer != Y
            return 1
        end
        echo "Cleaning homebrew"
        bbundle cleanup --force; and brew cleanup -s
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
