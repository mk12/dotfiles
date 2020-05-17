-- ========== Globals ==========================================================

local log = hs.logger.new("init", "info")

-- ========== Utilities ========================================================

-- Executes a command with the user environment. This loads dotfiles and sets
-- the PATH correctly. It incurs a small overhead, but it's worth it to not have
-- to hardcode the binary paths. Also, it might be unexpected if the shortcuts
-- use programs like tmux and ssh from /usr/bin if there are newer versions that
-- take precedence according to the PATH in /usr/local/bin.
local function executeWithUserEnv(cmd)
    return hs.execute(cmd, true)
end

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

-- Returns a function that opens the app to the given target.
local function openAppFn(app, target)
    return function()
        local cmd = "open -a '" .. app .. "' " .. target
        log.i("Running command: " .. cmd)
        if not os.execute(cmd) then
            log.e("Command failed")
        end
    end
end

-- ========== Kitty ============================================================

-- Kitty files and directories.
local kittyBinary = executeWithUserEnv("which kitty"):match("[^\r\n]+")
local kittyConfigDir = os.getenv("HOME") .. "/.config/kitty"
local kittySocketDir = os.getenv("HOME") .. "/.local/share/kitty"
os.execute("mkdir -p '" .. kittySocketDir .. "'")
local kittyRemotesFile = kittyConfigDir .. "/" .. "remotes"
local kittyColorsFile = kittyConfigDir .. "/" .. "colors.conf"
local kittyColorsDir = os.getenv("HOME") .. "/Projects/base16-kitty/colors"

-- Returns a Unix socket to use for the given kitty configuration.
local function kittySocketAddress(config)
    return "unix:" .. kittySocketDir .. "/" .. config .. ".sock"
end

-- Returns the addresses for all Unix sockets used by kitty instances.
local function allKittySocketAddresses()
    return {
        kittySocketAddress("kitty.conf"),
        kittySocketAddress("tmux.conf"),
    }
end

-- Launches kitty using the given config and options. Interprets config as a
-- path relative to kittyConfigDir. If options.lanchCommand is present, uses it
-- when starting the terminal. If options.newInstance is true, starts a new
-- instance; otherwise, opens a window in the existing instance for this config
-- (which is assumed to exist). If options.hideFromTasks is true, hides the app
-- from the macOS Dock and Cmd-Tab task bar.
local function launchKitty(config, options)
    local args = (
        "--single-instance --instance-group " .. config
        .. " --directory ~"
        .. " --config " .. kittyConfigDir .. "/" .. config
        .. " --override allow_remote_control=socket-only"
    )
    if options.hideFromTasks then
        args = args .. " --override macos_hide_from_tasks=yes"
    end

    local sessionPath
    if options.launchCommand then
        local text = "launch " .. options.launchCommand
        log.i("Using kitty session: " .. text)
        sessionPath = tempTextFile(text)
        if not sessionPath then
            return
        end
        args = args .. " --session " .. sessionPath
    end

    local cmd
    if options.newInstance then
        args = args .. " --listen-on '" .. kittySocketAddress(config) .. "'"
        cmd = "open -n -a kitty --args " .. args
    else
        cmd = kittyBinary .. " " .. args
    end

    log.i("Launching kitty: " .. cmd)
    local output, success = executeWithUserEnv(cmd)
    if not success then
        log.e("Command failed: " .. output)
    end
    if sessionPath then
        -- Give the app time to read the file before deleting it.
        hs.timer.doAfter(10, function()
            os.remove(sessionPath)
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
        if not socket or socket == "" then
            log.e("No socket for bell notification, cannot focus window")
            return
        end
        local cmd = (
            kittyBinary .. " @ --to '" .. socket .. "'"
            .. " focus-window --match=id:" .. windowID
        )
        log.i("Focusing kitty bell window: " .. cmd)
        if not os.execute(cmd) then
            log.e("Failed to focus kitty bell window")
        end
    end, {
        title = "Kitty",
        informativeText = "🔔 The bell rang!",
    }):send()
end

-- Shows or hides the main kitty instance (as opposed to the tmux instance).
local function showOrHideMainKittyInstance()
    local config = "kitty.conf"
    local app = getKittyApp(config)
    if not app then
        launchKitty(config, {newInstance = true, hideFromTasks = true})
        return
    end

    if not app:mainWindow() then
        log.i("Making a new kitty window")
        -- Use kitty --single-instance to open a new window. We could also
        -- select the "New OS Window" menu item, but this doesn't work with the
        -- macos_hide_from_tasks setting.
        launchKitty(config, {newInstance = false})
    elseif app:isFrontmost() then
        log.i("Hiding kitty")
        app:hide()
    else
        log.i("Showing kitty")
        app:activate()
    end
end

-- Returns a new command that starts in the given tmux session.
local function addTmuxToCommand(command, tmuxSession)
    local result = "tmux new -A -s " .. tmuxSession
    if command then
        return command .. " -t '" .. result .. "'"
    end
    return result
end

-- Opens a fullscreen kitty window attaching to tmux on the default host. The
-- default host is the one prefixed with an asterisk in the remotes file, or the
-- local machine if none is.
local function launchFullScreenTmuxKitty()
    local cmd
    local file = io.open(kittyRemotesFile)
    if file then
        for line in file:lines() do
            local name = line:match("^[^:]+")
            if name:sub(1, 1) == "*" then
                cmd = line:sub(#name + 2)
                break
            end
        end
        file:close()
    end
    local config = "tmux.conf"
    launchKitty(config, {
        launchCommand = addTmuxToCommand(cmd, "0"),
        newInstance = not getKittyApp(config),
    })
    local app = getKittyApp(config)
    local function fullScreen()
        app:mainWindow():setFullScreen(true)
    end
    -- When launching for the first time, wait for the window to be ready.
    if app and app:mainWindow() then
        fullScreen()
    else
        hs.timer.doAfter(1, fullScreen)
    end
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
    local file = io.open(kittyRemotesFile)
    if file then
        for line in file:lines() do
            local name = line:match("^[^:]+")
            local cmd = line:sub(#name + 2)
            name = name:gsub("^%*", "", 1)
            table.insert(choices, {
                text = name, subText = cmd, remote = true, command = cmd
            })
        end
        file:close()
    end
    return choices
end

-- Returns a list of terminal session choices for the given host choice (one of
-- the items from getHostChoices), to be used with hs.chooser.
local function getSessionChoices(host)
    local function text(localText, remoteText)
        return host.remote and remoteText or localText
    end

    return {
        {
            text = "Default",
            subText = text(
                "Create a window",
                "Connect to remote host"
            ),
            config = "kitty.conf",
            command = host.command,
        },
        {
            text = text("Local tmux", "Remote tmux"),
            subText = text(
                "Create or attach to local tmux session 0",
                "Create or attach to remote tmux session 0"
            ),
            config = "tmux.conf",
            command = addTmuxToCommand(host.command, "0"),
        },
        {
            text = text("Local tmux (detached)", "Remote tmux (detached)"),
            subText = text(
                "Create a window with tmux keybindings",
                "Connect to remote host with tmux keybindings"
            ),
            config = "tmux.conf",
            command = host.command,
        },
    }
end

-- Launches a new kitty window, prompting the user with chooser menus for the
-- host machine and the session type.
local function displayKittyLaunchChooser()
    local showChooser, onChooseHost, onChooseSession

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
        launchKitty(choice.config, {
            launchCommand = choice.command,
            newInstance = not getKittyApp(choice.config),
        })
    end

    showChooser()
end

-- Sets the color theme persistently for all current and future kitty instances.
local function setKittyColorTheme(theme)
    local path = kittyColorsDir .. "/base16-" .. theme .. ".conf"
    local cmd = ""
    for _, socket in ipairs(allKittySocketAddresses()) do
        -- Run the commands in the background with & so that all kitty instances
        -- change color simultaneously.
        cmd = (
            cmd .. kittyBinary .. " @ --to '" .. socket .. "'"
            .. " set-colors -a -c '" .. path .. "' & "
        )
    end
    log.i("Sending set-colors to all kitty sockets: " .. cmd)
    if not os.execute(cmd) then
        log.e("Command failed")
    end
    local file = io.open(kittyColorsFile, "w")
    if not file then
        log.e("Failed to open file " .. path)
        return nil
    end
    if not file:write("include " .. path .. "\n") then
        log.e("Failed to write to file " .. path)
    end
    file:close()
end

-- Global storing whether macOS Dark Mode was enabled when last checked.
local darkModeEnabled

-- Updates the kitty color theme to match the OS Dark Mode setting.
local function syncKittyToDarkMode()
    local dark = hs.host.interfaceStyle() == "Dark"
    if dark ~= darkModeEnabled then
        log.i("Updating kitty for dark mode = " .. (dark and "on" or "off"))
        setKittyColorTheme(dark and "solarized-dark" or "solarized-light")
    end
    darkModeEnabled = dark
end

-- ========== Chimes ===========================================================

-- Path to the timidity binary.
local timidityBinary = executeWithUserEnv("which timidity"):match("[^\r\n]+")

-- Flag indicating whether to play chimes every quarter hour.
local chimesEnabled = true

-- Toggles the chimesEnabled flag and displays a message on screen.
local function toggleChimesEnabled()
    chimesEnabled = not chimesEnabled
    local onOrOff = chimesEnabled and "on" or "off"
    log.i("Set chimesEnabled = " .. onOrOff)
    hs.alert("Chimes " .. onOrOff)
    if not chimesEnabled then
        local cmd =
            "pkill -f 'minster.sh' '" .. timidityBinary .. "'"
        log.i("Killing minster and timidity: " .. cmd)
        os.execute(cmd)
    end
end

-- If chimesEnabled is true, plays Westminster chimes for the current time.
local function playChimes()
    if chimesEnabled then
        -- Must use os.execute and & to avoid blocking the main thread.
        local cmd =
            "~/Projects/minster/minster.sh -t '" .. timidityBinary .. "' &"
        log.i("Playing chimes: " .. cmd)
        os.execute(cmd)
    else
        log.i("Not playing chimes because they are turned off")
    end
end

-- ========== Shortcuts ========================================================

-- Global modifier combination unlikely to be used by other programs.
local hyper = {"cmd", "option", "ctrl"}

-- Reload this config file.
hs.hotkey.bind(hyper, "R", hs.reload)

-- Commonly-used files and projects.
hs.hotkey.bind(hyper, "J",
    openAppFn("iA Writer", "~/ia/Journal/Today.txt"))
hs.hotkey.bind(hyper, "D",
    openAppFn("Visual Studio Code", "~/Projects/dotfiles"))
hs.hotkey.bind(hyper, "S",
    openAppFn("Visual Studio Code", "~/Projects/scripts"))
hs.hotkey.bind(hyper, "F",
    openAppFn("Visual Studio Code", "~/Projects/finance"))

-- Shortcuts for kitty.
hs.hotkey.bind({"ctrl"}, "space", showOrHideMainKittyInstance)
hs.hotkey.bind(hyper, "space", displayKittyLaunchChooser)
hs.hotkey.bind(hyper, "T", launchFullScreenTmuxKitty)
hs.hotkey.bind(hyper, "C", syncKittyToDarkMode)

-- Toggle Westminster chimes.
hs.hotkey.bind(hyper, "M", toggleChimesEnabled)

-- ========== Timers ===========================================================

syncKittyToDarkMode()
hs.timer.doEvery(hs.timer.minutes(1), syncKittyToDarkMode)

hs.timer.doAt("00:00", hs.timer.minutes(15), playChimes)

-- ========== Misc =============================================================

-- Install the hs binary. This just copies a symlink, so there's no harm in
-- repeating it every reload. Doing it in setupmacos.sh is too complicated.
hs.ipc.cliInstall()
