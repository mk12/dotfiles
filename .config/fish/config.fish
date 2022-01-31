# =========== Shared config ====================================================

if functions -q fenv
    fenv source ~/.profile
else
    echo (status -f): "fenv unavailable, not sourcing ~/.profile"
end

if not status --is-interactive
    exit
end

# =========== Shortcuts ========================================================

abbr -g g git
abbr -g v vim
abbr -g hex hexyl
abbr -g zb 'zig build'

alias vi=$EDITOR
alias vim=$EDITOR
alias e='emacsclient -t -a ""'

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

function code --description "Open in VS Code"
    # If not passing flags, use the open command on macOS because it's faster
    # and avoids a bouncing animation in the Dock.
    # https://github.com/microsoft/vscode/issues/60579
    not string match -q -- "-*" "$argv[1]"
    and test (uname -s) = Darwin
    if test $status -eq 0
        test -e $argv[1]; or touch $argv[1]
        open -b com.microsoft.VSCode $argv[1]
    else
        command code $argv
    end
end

function asdf --description "Wrapper for asdf"
    switch $argv[1]
        case shell
            command asdf export-shell-version fish $argv[2..] | source
        case '*'
            command asdf $argv
    end
end

# =========== Keybindings ======================================================

bind \ea add_alert
bind \ec kitty-colors "commandline -f repaint"
bind \er refish

# These bindings match https://github.com/mk12/vim-meta.
bind \e\[1\;4C forward-bigword
bind \e\[1\;4D backward-bigword
bind \e\[3\;3~ kill-word
bind \e\[3\;4~ kill-bigword
bind \eB backward-kill-bigword

# =========== Variables ========================================================

set fish_emoji_width 2

set fish_color_autosuggestion brblack
set fish_color_cancel --reverse
set fish_color_command blue
set fish_color_comment brblack
set fish_color_end yellow
set fish_color_error red
set fish_color_escape red
set fish_color_history_current --bold
set fish_color_normal normal
set fish_color_operator magenta
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

set pure_separate_prompt_on_error true

# =========== Local config =====================================================

source ~/.config/fish/local.fish
