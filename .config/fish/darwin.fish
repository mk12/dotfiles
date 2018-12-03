function notif --description "Send to Notification Center"
    terminal-notifier -activate com.apple.Terminal -message "$argv"
end

add_paths \
    /usr/local/opt/git/share/git-core/contrib/diff-highlight \
    /Library/TeX/texbin
