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

function insert_fzf --description "Insert a file or directory with fzf"
    set token (commandline -t)
    set parts (string split -n / $token)
    set i -1
    while true
        set root (string join / $parts[..$i])
        if test -d "$root" -o -z "$root"
            set -e parts[..$i]
            set query (string join / $parts)
            break
        end
        set i (math $i - 1)
    end
    set tmp (mktemp)
    set side bottom
    test $COLUMNS -ge 100; and set side right
    set files (
        fzf-command-helper $tmp init "$root" $argv \
        | fzf --query=$query --multi --keep-right --header-lines=1 \
        --preview="fzf-preview-helper {} '$tmp'" \
        --preview-window=$side \
        --bind="ctrl-o:reload(fzf-command-helper '$tmp' file)" \
        --bind="alt-o:reload(fzf-command-helper '$tmp' directory)" \
        --bind="alt-z:reload(fzf-command-helper '$tmp' z)" \
        --bind="alt-.:reload(fzf-command-helper '$tmp' toggle-hidden)" \
        --bind="alt-i:reload(fzf-command-helper '$tmp' toggle-ignore)" \
        --bind="alt-h:reload(fzf-command-helper '$tmp' home)+clear-query" \
        --bind="alt-up:reload(fzf-command-helper '$tmp' up)+clear-query" \
        --bind="alt-down:reload(fzf-command-helper '$tmp' down {})+clear-query" \
        | fzf-command-helper $tmp finish
    )
    set files (string split -n \n $files)
    # Workaround for https://github.com/fish-shell/fish-shell/issues/5945
    printf "\x1b[A"
    if test (count $files) -eq 0
        commandline -i " "
        commandline -f backward-delete-char
        return
    end
    for file in $files
        set escaped $escaped (string escape -- $file)
    end
    set escaped (string join ' ' $escaped)
    if test (commandline) != $token -o (count $files) -gt 1
        commandline -t "$escaped "
    else if test -d $files
        commandline -r "cd $escaped"
        commandline -f execute
    else if test -f $files -a ! -x $files
        commandline -r "$EDITOR $escaped"
        commandline -f execute
    else
        commandline -t "$escaped "
    end
end

function fzf_history --description "Search command history with fzf"
    history merge
    history -z \
        | fzf --read0 \
        --tiebreak=index \
        --query=(commandline) \
        --preview="echo -- {} | fish_indent --ansi" \
        --preview-window="bottom:3:wrap" \
        | read -lz cmd
    and commandline -- $cmd
    commandline -f repaint
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

# =========== Keybindings ======================================================

bind \co "insert_fzf file"
bind \cr fzf_history

bind \ea add_alert
bind \ec kitty-colors "commandline -f repaint"
bind \er refish
bind \eo "insert_fzf directory"
bind \ez "insert_fzf z"

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
