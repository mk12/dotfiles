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

set pure_separate_prompt_on_error true

# =========== Shared config ====================================================

# Source configuration shared with bashrc.
if functions -q fenv
    fenv source ~/.shellrc
else
    echo (status -f): "fenv unavailable, not sourcing shellrc"
end

# =========== Aliases ==========================================================

alias g=git
alias vi=$EDITOR
alias vim=$EDITOR

if command -qv exa
    alias l=exa
    alias ll='exa -l'
    alias la='exa -la'
else
    alias l=ls
end

if command -qv bat
    alias cat=bat
end

# =========== Functions ========================================================

function fish_source --description "Reload fish config files"
    source ~/.config/fish/config.fish
end

function gg --description "Print git overview"
    git log --oneline -n1; or return
    git branch
    git status -s
end

function upd --description "Update software"
    if command -qv brew
        echo "Updating homebrew"
        brew update; and brew upgrade; and brew cleanup -s
    end
    if set -q TMUX
        echo "Updating tmux"
        ~/.tmux/plugins/tpm/bin/update_plugins all
        ~/.tmux/plugins/tpm/bin/clean_plugins
    end
    if command -qv nvim
        echo "Updating neovim"
        command nvim +PlugUpgrade +PlugUpdate +PlugClean +qall
    end
    if command -qv vim
        echo "Updating vim"
        command vim +PlugUpgrade +PlugUpdate +PlugClean +qall
    end
end

set fish_emoji_width 2

function done --description "Print an emoji indicating exit status"
    set the_status $status
    if test $the_status -eq 0
        printf "\n\xf0\x9f\xa6\x84\n"
    else
        printf "\n\xf0\x9f\x92\xa5\n"
    end
    return $the_status
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

# Local configuration
set local ~/.config/fish/local.fish
if test -e $local
    source $local
end
