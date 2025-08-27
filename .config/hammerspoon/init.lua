-- ========== Globals ==========================================================

local log = hs.logger.new("init", "info")

-- ========== Utilities ========================================================

-- Helper for executeWithProfile.
local function popenWithProfile(cmd)
    return io.popen("/bin/sh -lc '" .. cmd .. "'")
end

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
    local f = popenWithProfile(cmd)
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

-- ========== Paths ============================================================

local homeDir = os.getenv("HOME")
local projectsDir = getUserEnv("PROJECTS")

-- ========== SSH ==============================================================

-- This stuff isn't used right now since I got rid of all the kitty stuff in
-- favor of using ghostty, but I might use it again in the future.

local sshConfigFile = homeDir .. "/.ssh/config"

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

-- ========== Ghostty ==========================================================

local function showOrHideGhostty()
    local bundleId = "com.mitchellh.ghostty"
    local app = hs.application.find(bundleId, true)
    if not app then
        hs.application.open(bundleId)
    elseif not app:mainWindow() then
        app:selectMenuItem({ "File", "New Window" })
    elseif app:isFrontmost() then
        app:hide()
    else
        app:activate()
    end
end

-- ========== Projects =========================================================

local function openProjectPicker()
    local f = popenWithProfile("z-projects")
    local choices = {}
    for line in f:lines() do
        table.insert(choices, { text = line })
    end
    f:close()
    local function onChoose(choice)
        if not choice then
            log.i("No project choice made")
            return
        end
        log.i("Got project choice: " .. choice.text)
        local path = projectsDir .. "/" .. choice.text
        os.execute("open -a Zed '" .. path .. "'")
    end
    local chooser = hs.chooser.new(onChoose)
    chooser:choices(choices)
    chooser:placeholderText("Choose a project")
    chooser:show()
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

local function setBuiltinDisplayScale(kind)
    local all = hs.screen.allScreens()
    for _, screen in ipairs(all) do
        if screen:name() == "Built-in Retina Display" then
            local mode = screen:currentMode()
            local dense = (kind == "auto" and #all == 1) or (kind == "toggle" and mode.w ~= 1728)
            local w = dense and 1728 or 1312 -- or 1496
            local h = dense and 1117 or 848  -- or 967
            local scale = 2
            screen:setMode(w, h, scale, mode.freq, mode.depth)
            return
        end
    end
end

local function fixBuiltinDisplayScale()
    setBuiltinDisplayScale("auto")
end

local function toggleBuiltinDisplayScale()
    setBuiltinDisplayScale("toggle")
end

-- ========== Diffing ==========================================================

local diffFileA = "/tmp/hammerspoon-diff-A"
local diffFileB = "/tmp/hammerspoon-diff-B"

local function startDiff()
    hs.eventtap.keyStroke({ "cmd" }, "C")
    local file, err = io.open(diffFileA, "w")
    if not file then
        log.e("Failed to open file: " .. err)
        return
    end
    file:write(hs.pasteboard.getContents())
    file:close()
end

local function endDiff()
    hs.eventtap.keyStroke({ "cmd" }, "C")
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
    hs.eventtap.keyStroke({ "cmd" }, "C")
    hs.pasteboard.setContents(old .. "\n" .. hs.pasteboard.getContents())
end

-- ========== Other functions ==================================================

-- Shortcut to navigate errors in kitty and fix them in VS Code.
-- I had this bound to the Kinesis Advantage2 "International Key" at work.
local function goToNextError()
    hs.eventtap.keyStroke({ "cmd" }, "S")
    local app = getKittyApp("tmux.conf")
    if not app then
        log.e("No tmux kitty running")
        return
    end
    app:activate()
    hs.eventtap.keyStroke({}, "return")
    hs.application.find("com.microsoft.VSCode", true):activate()
end

-- Paste and remove the first line of the text in the clipboard.
local function pasteFirstLine()
    local content = hs.pasteboard.getContents()
    local i = content:find("\n")
    local line, rest
    if i then
        line = content:sub(1, i - 1)
        rest = content:sub(i + 1)
    else
        line = content
        rest = ""
    end
    hs.pasteboard.setContents(line)
    hs.eventtap.keyStroke({ "cmd" }, "V")
    hs.pasteboard.setContents(rest)
end

-- Copy, remove newlines, switch to spreadsheet, enter.
local function copyForTaxFormsOne(i)
    hs.eventtap.keyStroke({ "cmd" }, "C")
    -- hs.eventtap.keyStroke({}, "tab")
    local text = hs.pasteboard.getContents()
    text = text:gsub("\n", " "):match("^%s*(.-)%s*$")
    hs.pasteboard.setContents(text)
    hs.application.find("com.apple.Safari", true):activate()
    -- hs.eventtap.keyStroke({"cmd"}, "`")
    hs.timer.doAfter(0.05, function()
        hs.eventtap.keyStroke({}, "return")
        hs.eventtap.keyStroke({ "cmd" }, "a")
        hs.eventtap.keyStroke({ "cmd" }, "v")
        hs.eventtap.keyStroke({}, "return")
        hs.application.find("com.apple.Preview", true):activate()
        -- hs.eventtap.keyStroke({"cmd", "shift"}, "`")
        -- if i < 6 then
        --     hs.timer.doAfter(0.05, function()
        --         copyForTaxFormsOne(i+1)
        --     end)
        -- end
    end)
end

local function copyForTaxForms()
    copyForTaxFormsOne(1)
end

local function toggleSideWindow()
    local windows = hs.window.orderedWindows()
    windows[3]:raise()
    windows[1]:raise()
end

local function copyToPreviewForm()
    hs.eventtap.keyStroke({ "cmd" }, "C")
    hs.timer.doAfter(0.05, function()
        hs.eventtap.keyStroke({}, "down")
        local text = hs.pasteboard.getContents()
        text = text:gsub("%.00$", "")
        hs.pasteboard.setContents(text)
        hs.application.find("com.apple.Preview", true):activate()
        hs.eventtap.keyStroke({ "cmd" }, "v")
        hs.eventtap.keyStroke({}, "tab")
        hs.application.find("com.apple.Safari", true):activate()
    end)
end

-- ========== Shortcuts ========================================================

-- Global modifier combination unlikely to be used by other programs.
local hyper = { "cmd", "option", "ctrl" }


-- Hammerspoon stuff.
hs.hotkey.bind(hyper, "R", hs.reload)
hs.hotkey.bind(hyper, "C", hs.openConsole)

-- Terminal, editor.
hs.hotkey.bind({ "ctrl" }, "space", showOrHideGhostty)
hs.hotkey.bind(hyper, "space", openProjectPicker)

-- Commonly-used files and projects.
hs.hotkey.bind(hyper, "J",
    openAppFn("iA Writer", homeDir .. "/Notes/Today.md"))
hs.hotkey.bind(hyper, "F",
    openAppFn("Zed", projectsDir .. "/finance"))

-- Shortcut for moving windows.
hs.hotkey.bind({ "ctrl" }, "§", moveFocusedWindowToNextScreen)

-- Shortcut for fixing display scale ("P" for "pixels").
hs.hotkey.bind(hyper, "P", fixBuiltinDisplayScale)
hs.hotkey.bind({ "cmd", "option", "ctrl", "shift" }, "P", toggleBuiltinDisplayScale)

-- Shortcuts for diffing.
-- Requires `npm install -g html2diff-cli`.
hs.hotkey.bind(hyper, "A", startDiff)
hs.hotkey.bind(hyper, "B", endDiff)

-- Shortcut for appending to clipboard.
hs.hotkey.bind(hyper, "/", copyAppend)

-- Mouse click with keyboard.
-- Keycode 145 is F1 without Fn (the lower brightness media key).
-- hs.hotkey.bind({}, 145, function()
--     -- hs.eventtap.leftClick(hs.mouse.absolutePosition())
--     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseDown"], hs.mouse.absolutePosition()):post()
-- end, function()
--     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseUp"], hs.mouse.absolutePosition()):post()
-- end)

-- hs.hotkey.bind(hyper, "Z", copyForTaxForms)
-- hs.hotkey.bind(hyper, "Z", copyToPreviewForm)
-- hs.hotkey.bind(hyper, "X", toggleSideWindow)

-- ========== Timers ===========================================================

-- Note: Recurring timers must be assigned to global variables, otherwise GC
-- will reclaim them and they stop working!
globalTimers = {}

-- ========== Misc =============================================================

-- Install the hs binary. This just copies a symlink, so there's no harm in
-- repeating it every reload. Doing it in setupmacos.sh is too complicated.
hs.ipc.cliInstall(homeDir .. "/.local")
