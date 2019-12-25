-- Install the hs binary. This just copies a symlink, so there's no harm in
-- repeating it every reload. Doing it in setupmacos.sh is too complicated.
hs.ipc.cliInstall()

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
    if app then
        if not app:mainWindow() then
            app:selectMenuItem({"kitty", "New OS window"})
        elseif app:isFrontmost() then
            app:hide()
        else
            app:activate()
        end
    else
        hs.application.launchOrFocus("hotkitty")
    end
end)

-- Hyper key for global shortcuts.
local hyper = {"cmd", "option", "ctrl"}

-- Returns a function to bind to a hyper shortcut.
local function hyperApp(name)
    return function()
        local app = hs.application.get(name)
        if app and app:mainWindow() then
            if app:isFrontmost() then
                app:hide()
            else
                app:activate()
            end
        else
            hs.application.launchOrFocus(name)
        end
    end
end

hs.hotkey.bind(hyper, "J", function()
    os.execute("open ~/ia/Journal/Today.txt")
end)
