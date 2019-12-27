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

-- Configuration directory for kitty.
local kittyConfigDir = os.getenv("HOME") .. "/.config/kitty"

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
    file:flush()
    return path
end

-- Returns a temporary file to use as a socket for kitty.
local function tempKittySocket()
    local output, success = hs.execute("mktemp -d")
    if not success then
        log.e("Failed to create temp socket")
        return nil
    end
    local dir = output:gsub("[ \r\n]+$", "", 1)
    return  dir .. "/kitty.sock"
end

-- Executes a command with the user environment. This loads dotfiles and sets
-- the PATH correctly. It incurs a small overhead, but it's worth it to not have
-- to hardcode the path to kitty. Also, it might be unexpected if the shortcuts
-- use programs like tmux and ssh from /usr/bin if there are newer versions that
-- take precedence according to the PATH in /usr/local/bin.
local function executeWithUserEnv(cmd)
    return hs.execute(cmd, true)
end

-- Launches kitty using the given config and launch command. Interprets config
-- as a path relative to kittyConfigDir. If newInstance is true, starts a new
-- instance; otherwise, opens a window in the existing instance for this config
-- (which is assumed to exist).
local function launchKitty(config, launchCommand, newInstance)
    local args = (
        "--single-instance --instance-group " .. config
        .. " --config " .. kittyConfigDir .. "/" .. config
        .. " --override allow_remote_control=socket-only"
        .. " --directory ~"
    )

    local session
    if launchCommand then
        local text = "launch " .. launchCommand
        log.i("Using kitty session: " .. text)
        session = tempTextFile(text)
        if not session then
            return
        end
        args = args .. " --session " .. session
    end

    local cmd
    if newInstance then
        local socket = tempKittySocket()
        if not socket then
            return
        end
        cmd = (
            "env KITTY_SOCKET='" .. socket .. "'"
            .. " open -n -a kitty --args " .. args
            .. " --listen-on 'unix:" .. socket .. "'"
        )
    else
        cmd = "kitty " .. args
    end

    log.i("Launching kitty: " .. cmd)
    local output, success = executeWithUserEnv(cmd)
    if not success then
        log.e("Command failed: " .. output)
    end
    if session then
        -- Give the app time to read the file before deleting it.
        hs.timer.doAfter(10, function()
            os.remove(session)
        end)
    end
end

-- Cached kitty application instances.
local kittyApps = {}

-- Returns the kitty application for the given config, or nil if it's not
-- running. Interprets config as a path relative to kittyConfigDir
local function getKittyApp(config)
    if not (kittyApps[config] and kittyApps[config]:isRunning()) then
        log.i("Refreshing kitty application cache for config: " ..config)
        kittyApps[config] = nil
        local output, _, _, rc =
            hs.execute("pgrep -lf kitty.app/Contents/MacOS/kitty")
        if not (rc == 0 or rc == 1) then
            log.e("Failed executing pgrep: " .. output)
            return nil
        end
        for line in output:gmatch("[^\r\n]+") do
            if line:find(config, 1, true) then
                local pid = line:match("[0-9]+")
                log.i("Found kitty process with PID " .. pid)
                kittyApps[config] = hs.application.applicationForPID(pid)
                if kittyApps[config] then
                    break
                end
                log.w("Failed to get application for PID " .. pid)
            end
        end
    end
    return kittyApps[config]
end

-- Sends a notification saying the bell rang in kitty.
function sendKittyBellNotification(socket, windowID)
    log.i("Sending bell notification for window " .. windowID)
    hs.notify.new(function()
        if socket and socket ~= "" then
            local cmd = (
                "kitty @ --to 'unix:" .. socket .. "'"
                .. " focus-window --match=id:" .. windowID
            )
            log.i("Focusing kitty bell window: " .. cmd)
            if not executeWithUserEnv(cmd) then
                log.e("Failed to focus kitty bell window")
            end
        else
            log.e("No socket for bell notification, cannot focus window")
        end
    end, {
        title = "Kitty",
        informativeText = "🔔 The bell rang!",
    }):send()
end

-- Shortcut to show/hide the main kitty app.
hs.hotkey.bind({"ctrl"}, "space", function()
    local config = "kitty.conf"
    local app = getKittyApp(config)
    if not app then
        launchKitty(config, nil, true)
        return
    end

    if not app:mainWindow() then
        log.i("Making a new kitty window")
        local newWindow = function()
            app:selectMenuItem({"kitty", "New OS window"})
        end
        -- Check if we're in a fullscreen window. In this case app:activate()
        -- will not switch away from the fullscreen app, so selectMenuItem
        -- doesn't work. Focusing the app with AppleScript works.
        local current = hs.window.focusedWindow()
        if current and current:isFullScreen() then
            log.i("Using applescript hack")
            hs.osascript.applescript([[
                tell application "System Events"
                    set frontmost of (first process whose unix id is ]] ..
                    app:pid() .. [[) to true
                end tell
            ]])
            -- Wait for the app to be activated before invoking selectMenuItem.
            hs.timer.doAfter(0.1, newWindow)
        else
            app:activate()
            newWindow()
        end
    elseif app:isFrontmost() then
        log.i("Hiding kitty")
        app:hide()
    else
        log.i("Showing kitty")
        app:activate()
    end
end)

-- Returns a list of the local tmux sessions.
local function getLocalTmuxSessions()
    list = {}
    output, success = executeWithUserEnv("tmux list-sessions -F '#S'")
    if success then
        for session in output:gmatch("[^\r\n]+") do
            table.insert(list, session)
        end
    end
    return list
end

-- Returns a new command that starts in the given tmux session.
local function addTmuxToCommand(command, tmuxSession)
    local result = "tmux new -A -s " .. tmuxSession
    if command then
        return command .. " -t '" .. result .. "'"
    end
    return result
end

-- Returns a list of terminal host choices, to be used with hs.chooser.
local function getHostChoices()
    local choices = {
        {
            text = "Localhost",
            subText = os.getenv("SHELL"),
            remote = false,
            command = nil,
        },
    }
    local file = io.open(kittyConfigDir .. "/remotes")
    if file then
        for line in file:lines() do
            local name = line:match("^[^:]+")
            local cmd = line:sub(#name + 2)
            table.insert(choices, {
                text = name, subText = cmd, remote = true, command = cmd
            })
        end
        file:close()
    else
        log.i("file " .. kittyConfigDir)
    end
    return choices
end

-- Returns a list of terminal session choices for the given host choice (one of
-- the items from getHostChoices), to be used with hs.chooser.
local function getSessionChoices(host)
    local choices = {
        {
            text = "Default",
            subText = "Normal keybindings",
            config = "kitty.conf",
            command = host.command,
        },
        {
            text = "tmux (attached)",
            subText = "tmux keybindings",
            config = "tmux.conf",
            command = addTmuxToCommand(host.command, "0"),
        },
        {
            text = "tmux (detached)",
            subText = "tmux keybindings",
            config = "tmux.conf",
            command = host.command,
        },
    }
    -- if not host.remote then
    --     for _, session in pairs(getLocalTmuxSessions()) do
    --         if session ~= "0" then
    --             table.insert(choices, {
    --                 text = "Tmux session " .. session,
    --                 config = "tmux.conf",
    --                 command = addTmuxToCommand(host.command, session),
    --             })
    --         end
    --     end
    -- end
    -- for _, item in pairs(choices) do
    --     if not item.subText then
    --         item.subText = item.command
    --     end
    -- end
    return choices
end

-- Shortcut to launch a new kitty terminal.
hs.hotkey.bind(hyper, "space", function()
    function showChooser()
        local chooser = hs.chooser.new(onChooseHost)
        chooser:choices(getHostChoices())
        chooser:placeholderText("Choose a host")
        chooser:show()
    end

    function onChooseHost(choice)
        if not choice then
            log.i("No choice made for kitty host")
            return
        end
        log.i("Got host choice: text = " .. choice.text .. ", command = "
            .. (choice.command or "nil"))
        local chooser = hs.chooser.new(onChooseSession)
        chooser:choices(getSessionChoices(choice))
        chooser:placeholderText("Choose a session")
        chooser:show()
    end

    function onChooseSession(choice)
        if not choice then
            log.i("No choice made for kitty session")
            return
        end
        log.i("Got session choice: text = " .. choice.text .. ", config = "
            .. choice.config .. ", command = " .. (choice.command or "nil"))
        local newInstance = not getKittyApp(choice.config)
        launchKitty(choice.config, choice.command, newInstance)
    end

    showChooser()
end)
