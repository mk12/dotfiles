function vs --description "Open in VS Code"
    open -a "Visual Studio Code" $argv
end

function totp --description "Copy TOTP code to clipboard"
    set -l secret (grep '^'$argv[1] < ~/.totp | cut -d' ' -f2)
    if test -z $secret
        echo "invalid label"
        return 1
    end
    oathtool --totp -b $secret | pbcopy
end
