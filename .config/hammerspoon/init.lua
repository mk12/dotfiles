-- ========== Globals ==========================================================

local log = hs.logger.new("init", "info")

-- ========== Utilities ========================================================

-- Executes a command with the user profile (/etc/profile and ~/.profile) so
-- that PATH and other environment variables are set correctly. It is slower
-- than the other execute functions because of this. In order of time:
--
--     os.execute(cmd) < hs.execute(cmd) < executeWithProfile(cmd)
--
-- The first option, os.execute(cmd), does not return the output, only the exit
-- status. Both of the others return the output and other information.
--
-- NOTE: I wrote this instead of using hs.execute(cmd, true) for two reasons.
-- First, that function uses $SHELL, but I don't want to use fish for this.
-- Second, that function puts double quotes around the command, meaning
-- variables are expanded by the *outer* sh invocation that io.popen uses.
local function executeWithProfile(cmd)
    local f = io.popen("/bin/sh -lc '" .. cmd .. "'")
    local s = f:read('*a')
    local status, exit_type, rc = f:close()
    return s, status, exit_type, rc
end

-- Returns the value of an environment variable after loading the user profile.
-- Prefer os.getenv(var) when the user profile is unnecessary (e.g., for $HOME).
local function getUserEnv(var)
    local value = executeWithProfile("echo $" .. var):match("[^\r\n]+")
    if not value then
        log.e("Environment variable not defined: " .. var)
    end
    return value
end

-- Returns the path to a binary. Looks in $PATH after loading the user profile.
local function getUserBinary(name)
    local path = executeWithProfile("which " .. name):match("[^\r\n]+")
    if not path then
        log.e("Binary not found: " .. name)
    end
    return path
end

-- Creates a temporary file, writes the given text to it, and returns the path.
-- If text is nil, does not create a file and simply returns nil.
local function tempTextFile(text)
    if not text then
        return nil
    end
    local path = os.tmpname()
    local file, err = io.open(path, "w")
    if not file then
        log.e("Failed to open temporary file: " .. err)
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

-- Directory containing my coding projects.
local projectsDir = getUserEnv("PROJECTS")

-- ========== SSH ==============================================================

local sshConfigFile = os.getenv("HOME") .. "/.ssh/config"

-- Array of {alias, user, hostname} records parsed from sshConfigFile.
local allSshHosts = {}
-- One of the elements of allSshHosts, or nil.
local defaultSshHost

(function()
    local file = io.open(sshConfigFile)
    if not file then
        log.i("no ssh config file")
        return
    end
    local default, alias, user, hostname
    local flush = function()
        if not alias then
            return
        end
        local host = {
            alias = alias,
            user = user or os.getenv("USER"),
            hostname = hostname or alias,
        }
        table.insert(allSshHosts, host)
        if default then
            defaultSshHost = host
        end
        default, alias, user, hostname = false, nil, nil, nil
    end
    for line in file:lines() do
        if line == "# Default" then
            default = true
        elseif not alias then
            alias = line:match("^Host ([^*]+)$")
        elseif line == "" then
            flush()
        else
            user = user or line:match("^%s*User (%g+)$")
            hostname = hostname or line:match("^%s*Host[Nn]ame (%g+)$")
        end
    end
    flush()
    file:close()
end)()

-- Returns a shell command to ssh into one of the hosts in allSshHosts.
local function sshCommand(host)
    if host then
        return "ssh " .. host.alias
    end
end

-- ========== Kitty ============================================================

-- Kitty files and directories.
local kittyBinary = getUserBinary("kitty")
local kittyConfigDir = os.getenv("HOME") .. "/.config/kitty"
local kittySocketDir = os.getenv("HOME") .. "/.local/share/kitty"
os.execute("mkdir -p '" .. kittySocketDir .. "'")
local kittyColorsFile = kittyConfigDir .. "/" .. "colors.conf"
local kittyColorsDir = projectsDir .. "/base16-kitty/colors"

-- Returns a Unix socket to use for the given kitty configuration.
local function kittySocketAddress(config)
    return "unix:" .. kittySocketDir .. "/" .. config .. ".sock"
end

-- Addresses for all Unix sockets used by kitty instances.
local allKittySocketAddresses = {
    kittySocketAddress("kitty.conf"),
    kittySocketAddress("tmux.conf"),
}

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
    -- We *could* use full paths to tmux and ssh, and then use hs.execute
    -- instead of executeWithProfile. However, we actually need the user profile
    -- for the kitty process so that it can locate kitty-bell-notify, and for
    -- the tmux process so that it can locate tmux-session (this won't help a
    -- remote tmux -- we assume ssh will start a login shell that loads the
    -- remote user profile and runs tmux in that).
    local output, success = executeWithProfile(cmd)
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
                kittyApps[config] =
                    hs.application.applicationForPID(tonumber(pid))
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
local function addTmuxToCommand(sshCommand, tmuxSession)
    local tmux = "tmux new -A -s " .. tmuxSession
    if sshCommand then
        return sshCommand .. " -t '" .. tmux .. "'"
    end
    return tmux
end

-- Opens a fullscreen kitty window attaching to tmux on the default host. The
-- default host is the one marked "# Default", or the local machine if none is.
local function launchFullScreenTmuxKitty()
    local config = "tmux.conf"
    launchKitty(config, {
        launchCommand = addTmuxToCommand(sshCommand(defaultSshHost), "0"),
        newInstance = not getKittyApp(config),
    })
    -- When launching for the first time, wait for the window to be ready.
    if app and app:mainWindow() then
        app:mainWindow():setFullScreen(true)
    else
        hs.timer.doAfter(1, function()
            local app = getKittyApp(config)
            if not app then
                log.e("Still no tmux kitty app after 1s")
                return
            end
            if not app:mainWindow() then
                log.e("Still no tmux kitty main window after 1s")
                return
            end
            app:mainWindow():setFullScreen(true)
        end)
    end
end

-- List of terminal host choices, to be used with hs.chooser.
local hostChoices = (function ()
    local choices = {
        {
            text = "localhost",
            subText = os.getenv("SHELL"),
            remote = false,
            command = nil,
        },
    }
    for _, host in ipairs(allSshHosts) do
        table.insert(choices, {
            text = host.alias,
            subText = "ssh " .. host.user .. "@" .. host.hostname,
            remote = true,
            command = sshCommand(host),
        })
    end
    return choices
end)()

-- Returns a list of terminal session choices for the given host choice (one of
-- the items from hostChoices), to be used with hs.chooser.
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
        chooser:choices(hostChoices)
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
    for _, socket in ipairs(allKittySocketAddresses) do
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
    local file, err = io.open(kittyColorsFile, "w")
    if not file then
        log.e("Failed to open kitty colors file: " .. err)
        return nil
    end
    if not file:write("include " .. path .. "\n") then
        log.e("Failed to write to file " .. kittyColorsFile)
    end
    file:close()
end

local cbqnConfigFile = os.getenv("HOME") .. "/.config/cbqn_repl.txt"

-- Updates the CBQN color theme by editing the cbqnConfigFile file.
local function setCbqnColorTheme(dark)
    local name = dark and "dark" or "light"
    log.i("Setting theme to " .. name .. " in " .. cbqnConfigFile)
    local file, err = io.open(cbqnConfigFile, "r+")
    if not file then
        log.e("Failed to open CBQN config file: " .. err)
    end
    for line in file:lines() do
        if line:match("^theme=%d$") then
            file:seek("cur", -2)
            file:write(dark and "1" or "2")
            break
        end
    end
    file:close()
end

-- Global storing whether macOS Dark Mode was enabled when last checked.
local darkModeEnabled

-- Updates the kitty color theme to match the OS Dark Mode setting.
local function syncKittyToDarkMode(force)
    local dark = hs.host.interfaceStyle() == "Dark"
    if force or dark ~= darkModeEnabled then
        log.i("Updating kitty for dark mode = " .. (dark and "on" or "off"))
        setKittyColorTheme(dark and "eighties" or "solarized-light")
        setCbqnColorTheme(dark)
    end
    darkModeEnabled = dark
end

local function syncKittyToDarkModeLazy()
    syncKittyToDarkMode(false)
end

local function syncKittyToDarkModeForce()
    syncKittyToDarkMode(true)
end

-- ========== Chimes ===========================================================

-- Path to the timidity binary.
local timidityBinary = getUserBinary("timidity")

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
        local cmd = (
            projectsDir .. "/minster/minster.sh -t '" .. timidityBinary .. "'"
            .. " >> /tmp/minster.log 2>&1 &"
        )
        log.i("Playing chimes: " .. cmd)
        os.execute(cmd)
    else
        log.i("Not playing chimes because they are turned off")
    end
end

-- ========== Move windows =====================================================

local function moveFocusedWindowToNextScreen()
    local w = hs.window.focusedWindow()
    if not w then
        log.i("there is no focused window")
        return
    end
    local screens = hs.screen.allScreens()
    local current = w:screen()
    local found
    for i, screen in ipairs(screens) do
        if screen == current then
            found = i
            break
        end
    end
    if not found then
        log.e("could not find screen for window '" .. w:title() .. "'")
        return
    end
    if w:isFullScreen() then
        full_screen = true
        w:setFullScreen(false)
        hs.timer.doAfter(0.6, function()
            w:setFullScreen(true)
        end)
    end
    w:moveToScreen(
        screens[found % #screens + 1],
        true, -- maintain size
        true, -- ensure in bounds
        false
    )
end

-- ========== Display scaling ==================================================

local function fixBuiltinDisplayScale()
    local all = hs.screen.allScreens()
    for _, screen in ipairs(all) do
        if screen:name() == "Built-in Retina Display" then
            local mode = screen:currentMode()
            local alone = #all == 1
            local w = alone and 1728 or 1496
            local h = alone and 1117 or 967
            local scale = 2
            screen:setMode(w, h, scale, mode.freq, mode.depth)
            return
        end
    end
end

-- ========== Diffing ==========================================================

local diffFileA = "/tmp/hammerspoon-diff-A"
local diffFileB = "/tmp/hammerspoon-diff-B"

local function startDiff()
    hs.eventtap.keyStroke({"cmd"}, "C")
    local file, err = io.open(diffFileA, "w")
    if not file then
        log.e("Failed to open file: " .. err)
        return
    end
    file:write(hs.pasteboard.getContents())
    file:close()
end

local function endDiff()
    hs.eventtap.keyStroke({"cmd"}, "C")
    local file, err = io.open(diffFileB, "w")
    if not file then
        log.e("Failed to open file: " .. err)
        return
    end
    file:write(hs.pasteboard.getContents())
    file:close()
    local output, success = executeWithProfile(
        "git diff -w --no-index -- " .. diffFileA .. " " .. diffFileB
        .. " | diff2html -i stdin -s side")
    if not success then
        log.e("diff2html failed:\n\n" .. output)
    end
end

-- ========== Clipboard ========================================================

local function copyAppend()
    local old = hs.pasteboard.getContents()
    hs.eventtap.keyStroke({"cmd"}, "C")
    hs.pasteboard.setContents(old .. "\n" .. hs.pasteboard.getContents())
end

-- ========== Shortcuts ========================================================

-- Global modifier combination unlikely to be used by other programs.
local hyper = {"cmd", "option", "ctrl"}

-- Reload this config file.
hs.hotkey.bind(hyper, "R", hs.reload)

-- Commonly-used files and projects.
hs.hotkey.bind(hyper, "J",
    openAppFn("iA Writer", projectsDir .. "/journal/Today.txt"))
hs.hotkey.bind(hyper, "F",
    openAppFn("Visual Studio Code", projectsDir .. "/finance"))

-- TODO: Make a single shortcut to choose among git projects.
-- hs.hotkey.bind(hyper, "D",
--     openAppFn("Visual Studio Code", projectsDir .. "/dotfiles"))
-- hs.hotkey.bind(hyper, "S",
--     openAppFn("Visual Studio Code", projectsDir .. "/scripts"))

-- Shortcuts for kitty.
hs.hotkey.bind({"ctrl"}, "space", showOrHideMainKittyInstance)
hs.hotkey.bind(hyper, "space", launchFullScreenTmuxKitty)
hs.hotkey.bind(hyper, "T", displayKittyLaunchChooser)
hs.hotkey.bind(hyper, "C", syncKittyToDarkModeForce)

-- Toggle Westminster chimes.
hs.hotkey.bind(hyper, "M", toggleChimesEnabled)

-- Shortcut for moving windows.
hs.hotkey.bind({"ctrl"}, "§", moveFocusedWindowToNextScreen)

-- Shortcut for fixing display scale ("P" for "pixels").
hs.hotkey.bind(hyper, "P", fixBuiltinDisplayScale)

-- Shortcuts for diffing.
-- Requires `npm install -g html2diff-cli`.
hs.hotkey.bind(hyper, "A", startDiff)
hs.hotkey.bind(hyper, "B", endDiff)

-- Shortcut for appending to clipboard.
hs.hotkey.bind(hyper, "/", copyAppend)

-- ========== Timers ===========================================================

-- Note: Recurring timers must be assigned to global variables, otherwise GC
-- will reclaim them and they stop working!
globalTimers = {}

syncKittyToDarkModeForce()
table.insert(globalTimers,
    hs.timer.doEvery(hs.timer.minutes(1), syncKittyToDarkModeLazy))

table.insert(globalTimers,
    hs.timer.doAt("00:00", hs.timer.minutes(15), playChimes))

-- ========== Misc =============================================================

-- Install the hs binary. This just copies a symlink, so there's no harm in
-- repeating it every reload. Doing it in setupmacos.sh is too complicated.
hs.ipc.cliInstall(os.getenv("HOME") .. "/.local")

-- ========== Local config =====================================================

-- TODO: Add way of accessing hyper, executeWithProfile, etc. in local.lua.
require("local")
