-- Install the hs binary. This just copies a symlink, so there's no harm in
-- repeating it every reload. Doing it in setupmacos.sh is too complicated.
hs.ipc.cliInstall()

-- Hyper key for global shortcuts.
local hyper = {"cmd", "option", "ctrl"}

-- Create a keybinding for hyper+key to open the given app to the target.
local function hyperBind(key, app, target)
    hs.hotkey.bind(hyper, key, function()
        os.execute("open -a '" .. app .. "' " .. target)
    end)
end

hyperBind("J", "iA Writer", "~/ia/Journal/Today.txt")
hyperBind("D", "Visual Studio Code", "~/Projects/dotfiles")
hyperBind("S", "Visual Studio Code", "~/Projects/scripts")
hyperBind("F", "Visual Studio Code", "~/Projects/finance")

-- Sends a notification saying the bell rang in kitty.
function sendKittyBellNotification()
    hs.notify.new(function()
        hs.application.launchOrFocus("kitty")
    end, {
        title="Kitty",
        informativeText="🔔 The bell rang!",
    }):send()
end

-- Returns the hotkitty app if it is currently running.
local function getHotkitty()
    if not (hotkitty and hotkitty:isRunning()) then
        hotkitty = nil
        for _, app in pairs(hs.application.runningApplications()) do
            if app:path() == "/Applications/hotkitty.app" then
                hotkitty = app
                break
            end
        end
    end
    return hotkitty
end

-- Hotkey to show/hide the hotkitty window.
hs.hotkey.bind({"ctrl"}, "space", function()
    local app = getHotkitty()
    if not app then
        -- hs.execute("open -a hotkitty --args --config ~/.config/kitty/base.conf")
        hs.application.launchOrFocus("hotkitty")
        return
    end

    if not app:mainWindow() then
        local newWindow = function()
            app:selectMenuItem({"kitty", "New OS window"})
        end
        local current = hs.window.focusedWindow()
        if current and current:isFullScreen() then
            -- Calling app:activate() does not switch spaces away from the
            -- fullscreen app, so selectMenuItem doesn't work.
            hs.osascript.applescript('tell application "hotkitty" to activate')
            hs.timer.doAfter(0.1, newWindow)
        else
            app:activate()
            newWindow()
        end
    elseif app:isFrontmost() then
        app:hide()
    else
        app:activate()
    end
end)
