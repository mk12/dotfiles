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

-- USE a CHOOSER to pick profile!

-- Global table storing Kitty application instances.
local _kitty = {}

-- Launches a Kitty instance for the hotkey window (no tmux bindings).
local function launchHotkeyKitty()
    hs.execute("open -n -a kitty --args --config ~/.config/kitty/base.conf")
    _kitty.hotkey = hs.application.frontmostApplication()
end

-- Returns the hotkey instance of Kitty, if it's running.
local function getHotkeyKitty()
    if _kitty.hotkey and not _kitty.hotkey:isRunning() then
        _kitty.hotkey = nil
    end
    return _kitty.hotkey
end

-- Returns the main instance of Kitty, if it's running.
local function getMainKitty()
    if not (_kitty.main and _kitty.main:isRunning()) then
        _kitty.main = nil
        for _, app in pairs(hs.application.runningApplications()) do
            if app:bundleID() == "net.kovidgoyal.kitty"
                    and app:pid() ~= _kitty.hotkey:pid() then
                _kitty.main = app
                break
            end
        end
    end
    return _kitty.main
end

-- Sends a notification saying the bell rang in kitty.
function sendKittyBellNotification()
    hs.notify.new(function()
        getMainKitty():activate()
    end, {
        title="Kitty",
        informativeText="🔔 The bell rang!",
    }):send()
end

-- Hotkey to show/hide the Kitty hotkey window.
hs.hotkey.bind({"ctrl"}, "space", function()
    local app = getHotkeyKitty()
    if not app then
        launchHotkeyKitty()
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
            hs.osascript.applescript([[
                tell application "System Events"
                    set the frontmost of (first process whose unix id is ]] .. app:pid() .. [[) to true
                end tell
            ]])
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
