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

# =========== Shortcuts ========================================================

abbr g git
abbr v vim

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

function refish --description "Reload fish config files"
    source ~/.config/fish/config.fish
end

function z --description "Jump around"
    set -g prev_z_argv $argv
    __z $argv
end

function zi --description "Like z, but choose with fzf"
    if test (count $argv) -ge 1
        set -g prev_z_argv $argv
    end
    if not set result (__z $prev_z_argv -l 2> /dev/null | fzf)
        return
    end
    cd (echo $result | sed -E 's/^[0-9.]+[ \t]+//')
end

function gg --description "Print git overview"
    git log --oneline -n1; or return
    git branch
    git status -s
end

function tm --description "Connect to local or remote tmux session"
    if test (count $argv) -ge 1
        ssh $argv -t 'tmux new -A -s 0'
    else
        tmux new -A -s 0
    end
end

function alert --description "Ring the bell without changing exit status"
    set the_status $status
    printf "\a"
    return $the_status
end

function add_alert --description "Add '; alert' to the end of the command"
    if test -z (commandline -b)
        commandline -a $history[1]
    end
    if commandline -b | string match -q -r -v "; *alert;?\$"
        commandline -aj "; alert;"
    end
end

function fzf_open_project --description "Open a project file using fzf"
    if test -d .git
        set -g FZF_OPEN_COMMAND 'git ls-files'
        __fzf_open --editor
        set -e FZF_OPEN_COMMAND
    else
        set -e FZF_OPEN_COMMAND
        __fzf_open --editor
    end
end

# Workaround for https://github.com/fish-shell/fish-shell/issues/6270
function __fish_describe_command; end

# =========== Keybindings ======================================================

# Use only the fzf bindings Ctrl-o, Ctrl-r.
set -x FZF_LEGACY_KEYBINDINGS 0
bind -e \ec \eC \eo \eO
bind -M insert -e \ec \eC \eo \eO

bind \ea add_alert
bind \ec kitty-colors "commandline -f repaint"
bind \eo fzf_open_project
bind \ek kill-line
bind \eK backward-kill-bigword
bind \eD kill-bigword
bind \e\[1\;4D backward-bigword
bind \e\[1\;4C forward-bigword

# =========== Variables ========================================================

set fish_emoji_width 2

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
set fish_pager_color_progress cyan --bold
set fish_color_search_match --background=brgreen

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
