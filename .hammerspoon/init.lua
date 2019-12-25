-- Install spoons.
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.repos.default = {
    url = "https://github.com/mk12/Spoons",
    desc = "mk12's Hammerspoon Spoon repository",
    branch = "master",
}
spoon.SpoonInstall:andUse("UnsplashRandom")

-- Install the hs binary. This just copies a symlink, so there's no harm in
-- repeating it every reload. Doing it in setupmacos.sh is too complicated.
hs.ipc.cliInstall()

-- Send a notification saying the bell rang in kitty.
function kittyNotifyBell()
    hs.notify.new(function()
        hs.application.launchOrFocus("kitty")
    end, {
        title="Kitty",
        informativeText="🔔 The bell rang!",
    }):send()
end

-- Return the hotkitty app if it is currently running.
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

-- Show/hide the hotkitty window.
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

-- TODO super?
hs.hotkey.bind({"cmd", "option", "ctrl"}, "J", function()
    os.execute("open ~/ia/Journal/Today.txt")
end)
