-- Install the hs binary. This just copies a symlink, so there's no harm in
-- repeating it every reload. Doing it in setupmacos.sh is too complicated.
hs.ipc.cliInstall()

-- Logger for printing to the Hammerspoon console.
local log = hs.logger.new("init", "info")

-- Global modifier combination unlikely to be used by other programs.
local hyper = {"cmd", "option", "ctrl"}

-- Shortcut to reload this config file.
hs.hotkey.bind(hyper, "R", hs.reload)

-- Creates a keybinding for hyper+key to open the given app to the target.
local function hyperBindOpen(key, app, target)
    hs.hotkey.bind(hyper, key, function()
        local cmd = "open -a '" .. app .. "' " .. target
        log.i("Running command: " .. cmd)
        if not os.execute(cmd) then
            log.e("Command failed")
        end
    end)
end

-- Shortcuts for commonly-used files and projects.
hyperBindOpen("J", "iA Writer", "~/ia/Journal/Today.txt")
hyperBindOpen("D", "Visual Studio Code", "~/Projects/dotfiles")
hyperBindOpen("S", "Visual Studio Code", "~/Projects/scripts")
hyperBindOpen("F", "Visual Studio Code", "~/Projects/finance")

-- Configuration directory for Kitty.
local kittyConfigDir = "~/.config/kitty"

-- Creates a temporary file, writes the given text to it, and returns the path.
-- If text is nil, does not create a file and simply returns nil.
local function tempTextFile(text)
    if not text then
        return nil
    end
    local path = os.tmpname()
    local file = io.open(path, "w")
    if not file then
        log.e("Failed to open temporary file " .. path)
        return nil
    end
    if not file:write(text) then
        log.e("Failed to write to temporary file " .. path)
    end
    return path
end

-- Returns a temporary file to use as a socket for Kitty.
local function tempKittySocket()
    local dir, success = hs.execute("mktemp -d")
    if not success then
        log.e("Failed to create temp socket")
        return nil
    end
    return dir:gsub("[ \r\n]+$", "", 1) .. "/kitty.sock"
end

-- Launches Kitty using the given config and launch command. Interprets config
-- as a path relative to kittyConfigDir. If newInstance is true, starts a new
-- instance; otherwise, opens a window in the existing instance for this config
-- (which is assumed to exist).
local function launchKitty(config, launchCmd, newInstance)
    local session
    local sessionArgs = ""
    if launchCmd then
        session = tempTextFile("launch " .. launchCmd)
        if not session then
            return
        end
        sessionArgs = "--session " .. session
    end

    local cmd
    if newInstance then
        local socket = tempKittySocket()
        if not socket then
            return
        end
        cmd = (
            "env KITTY_SOCKET='" .. socket .. "'"
            .. " open -n -a kitty --args --single-instance --instance-group "
            .. config .. " --config " .. kittyConfigDir .. "/" .. config
            .. sessionArgs .. " --override allow_remote_control=socket-only"
            .. " --listen-on 'unix:" .. socket .. "'"
        )
    else
        cmd = (
            "/usr/local/bin/kitty --single-instance --instance-group " .. config
            .. sessionArgs
        )
    end

    log.i("Launching kitty: " .. cmd)
    if not os.execute(cmd) then
        log.e("Command failed")
    end
    if session then
        os.remove(session)
    end
end

-- Cached Kitty application instances.
local kittyApps

-- Returns the Kitty application for the given config, or nil if it's not running.
local function getKittyApp(config)
    if not (defaultKittyApp and defaultKittyApp:isRunning()) then
        log.i("Refreshing default kitty cache")
        defaultKittyApp = nil
        local output, success =
            hs.execute("pgrep -lf kitty.app/Contents/MacOS/kitty")
        if not success then
            log.e("Failed executing pgrep: " .. output)
            return nil
        end
        for line in output:gmatch("[^\r\n]+") do
            if not line:find("tmux.conf", 1, true) then
                local pid = line:match("[0-9]+")
                log.i("Found non-tmux kitty process with PID " .. pid)
                defaultKittyApp = hs.application.applicationForPID(pid)
                if defaultKittyApp then
                    break
                end
                log.w("Failed to get application for PID " .. pid)
            end
        end
    end
    return defaultKittyApp
end

-- Table of cached window instances for tmux Kitty.
local tmuxKittyWindows = {}

-- Window filter that finds all tmux Kitty windows.
local tmuxKittyWindowFilter =
hs.window.filter.new({kitty = {}})

-- Returns the tmux-keybindings Kitty window instance for the given session
-- (Kitty session name, not tmux session), or nil if it doesn't exist.
local function getTmuxKittyWindow(session)
    -- TODO consider using applescript, more reliable
    if not (tmuxKittyWindows[session]
            and tmuxKittyWindows[session]:application():isRunning()
            and tmuxKittyWindows[session]:size().area > 0) then
        log.i("Refreshing tmux kitty cache (" .. session .. ")")
        tmuxKittyWindows[session] = nil
        local windows = tmuxKittyWindowFilter:getWindows()
        for _, window in pairs(windows) do
            if window:title() == "tmux: " .. session then
                log.i("Found window")
                tmuxKittyWindows[session] = window
                break
            end
        end
    end
    return tmuxKittyWindows[session]
end

-- Sends a notification saying the bell rang in kitty.
function sendKittyBellNotification(socket, window_id)
    hs.alert("id " .. window_id .. ", socket: " .. socket)
    --[[
    -- grab terminal title from window, show as subtitle!!!
    log.i("Sending bell notification for window (" .. session .. ")")
    hs.notify.new(function()
        if session then
            local window = getTmuxKittyWindow(session)
            log.i("Got session")
            if window then
                log.i("Got window")
                window:focus()
            end
        end
    end, {
        title = "Kitty",
        subTitle = subTitle,
        informativeText = "🔔 The bell rang!",
    }):send()
    --]]
end

-- Hotkey to show/hide the Kitty hotkey window.
hs.hotkey.bind({"ctrl"}, "space", function()
    local app = getDefaultKittyApp()
    if not app then
        launchDefaultKitty()
        return
    end
    
    if not app:mainWindow() then
        log.i("Making a new window for default kitty")
        local newWindow = function()
            app:selectMenuItem({"kitty", "New OS window"})
        end
        local current = hs.window.focusedWindow()
        if current and current:isFullScreen() then
            log.i("Using applescript hack")
            -- Calling app:activate() does not switch spaces away from the
            -- fullscreen app, so selectMenuItem doesn't work.
            hs.osascript.applescript([[
                tell application "System Events"
                    set the frontmost of (first process whose unix id is ]] ..
                    app:pid() .. [[) to true
                end tell
            ]])
            hs.timer.doAfter(0.1, newWindow)
        else
            app:activate()
            newWindow()
        end
    elseif app:isFrontmost() then
        log.i("Hiding default kitty")
        app:hide()
    else
        log.i("Showing default kitty")
        app:activate()
    end
end)

hs.hotkey.bind(hyper, "space", function()
    function onChoice(choice)
        if not choice then
            return
        end
        launchTmuxKitty(choice.text)
    end
    -- todo read from fs
    hs.chooser.new(onChoice):choices({
        {text = "localhost", subText = "tmux new -A -s 0"},
        {text = "detached"},
    }):placeholderText("Choose a session"):show()
end)
