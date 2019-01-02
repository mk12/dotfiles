function totp
    set secret (grep '^'$argv[1] < ~/.totp | cut -d' ' -f2)
    if test -z $secret
        echo "invalid label"
        return 1
    end
    oathtool --totp -b $secret | pbcopy
end

function notif --description "Send to Notification Center"
    terminal-notifier -activate com.apple.Terminal -message "$argv"
end
