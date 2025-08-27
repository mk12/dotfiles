# =========== Shared config ====================================================

# From https://github.com/oh-my-fish/plugin-foreign-env/blob/master/functions/fenv.main.fish
# Copyright 2015 Derek Willian Stavis (MIT Licensed)
function fenv --description "Run bash script and import variables it modifies"
    bash -c "$argv && env -0 >&31" 31>| while read -l -z env_var
        set -l kv (string split -m 1 = $env_var) || continue
        contains $kv[1] _ SHLVL PWD && continue
        string match -rq '^BASH_.*%%$' $kv[1] && continue
        if ! set -q $kv[1] || test "$$kv[1]" != $kv[2] || ! set -qx $kv[1]
            set -gx $kv
        end
    end
    return $pipestatus[1]
end

fenv source ~/.profile

if not status --is-interactive
    exit
end

# =========== Plugins ==========================================================

set my_fish_plugins jorgebucaran/fisher \
    pure-fish/pure jethrokuan/z mk12/fish-{fzf,vscode}

function replug --description "Update plugins, symlinking local ones"
    set config_dir (status dirname)
    for plugin in $my_fish_plugins
        set local $PROJECTS/(string split / $plugin)[2]
        if ! test -d $local || ! git -C $local remote -v | grep -q $plugin
            set -a external $plugin
            continue
        end
        for dir in conf.d functions completions
            set install $config_dir/$dir
            if set sources $local/$dir/* && test (count $sources) -gt 0
                ln -sf $sources $install/
            end
            for link in (find $install -type l ! -exec test -e {} \; -print)
                echo "Removing stale symlink $link"
                rm -f $link
            end
        end
    end
    printf "%s\n" $external | sort >$config_dir/fish_plugins
    if ! functions -q fisher
        curl -sL https://git.io/fisher | source
    end
    fisher update
end

# =========== Shortcuts ========================================================

abbr -g g git
abbr -g v vim
abbr -g c zed
abbr -g hex hexyl
abbr -g zb 'zig build'

alias vi=$EDITOR
alias vim=$EDITOR
alias e='emacsclient -t -a ""'

if command -qv eza
    alias l=eza
    alias ll='eza -l'
    alias la='eza -la'
else
    alias l=ls
end

if command -qv bat
    alias cat=bat
end

if command -qv git-branchless
    alias git='git-branchless wrap --'
end

# =========== Functions ========================================================

function refish --description "Reload fish config files"
    source ~/.config/fish/config.fish
    printf "# Reloaded fish config!\n\n\n"
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
    set -l message "succeeded"
    if test $the_status -ne 0
        set message "failed with status $the_status"
    end
    printf "\x1b]9;Command $message\a"
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
bind \e\[107\;6u kill-whole-line

# Use \e\\ for undo instead of the default (\cz, \c/, or \c-) so that vim can
# use it too and terminal can map cmd+z to it. (Vim needs \c- for navigation.)
bind \e\\ undo
bind \e/ redo

# =========== Variables ========================================================

set fish_term24bit 0
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

# Fish doesn't allow a 0-255 color palette number, so I use these hex colors
# which match xterm defaults in slots 16-21 where I have base16 colors.
set fish_color_search_match "#0000ff" "--background=#000087"

set pure_separate_prompt_on_error true
set pure_enable_git false

# =========== Local config =====================================================

source ~/.config/fish/local.fish
