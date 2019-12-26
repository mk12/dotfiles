-- Install the hs binary. This just copies a symlink, so there's no harm in
-- repeating it every reload. Doing it in setupmacos.sh is too complicated.
hs.ipc.cliInstall()

local log = hs.logger.new("init", "info")

-- Global modifier combination unlikely to be used by other programs.
local hyper = {"cmd", "option", "ctrl"}

-- Creates a keybinding for hyper+key to open the given app to the target.
local function hyperBind(key, app, target)
  hs.hotkey.bind(hyper, key, function()
    local cmd = "open -a '" .. app .. "' " .. target
    log.i("Running command: " .. cmd)
    if not os.execute(cmd) then
      log.e("Command failed")
    end
  end)
end

hyperBind("J", "iA Writer", "~/ia/Journal/Today.txt")
hyperBind("D", "Visual Studio Code", "~/Projects/dotfiles")
hyperBind("S", "Visual Studio Code", "~/Projects/scripts")
hyperBind("F", "Visual Studio Code", "~/Projects/finance")

local kittyConfigDir = "~/.config/kitty"
local kittyBundleID = "net.kovidgoyal.kitty"

-- Launches a Kitty instance with default keybindings.
local function launchDefaultKitty()
  local cmd = "open -n -a kitty"
  log.i("Launching default kitty: " .. cmd)
  if not os.execute(cmd) then
    log.e("Command failed")
  end
end

-- Launches a Kitty instance with tmux keybindings, using the given session.
local function launchTmuxKitty(session)
  local cmd = (
  "open -n -a kitty --args --single-instance --instance-group tmux" ..
  " --config " .. kittyConfigDir .. "/tmux.conf" ..
  " --title 'tmux: " .. session .. "'" ..
  -- Allowing the tmux application to remain open with no windows is
  -- problematic: which session will it use when you click the icon?
  -- Additionally, we assume an app with no windows is default, not tmux.
  -- " --override macos_quit_when_last_window_closed=yes" ..
  -- DOESNT WORK, SETS IT FOR ALL WINDOWS.
  -- " --override command_on_bell=" ..
  --     "'/usr/local/bin/hs -c" ..
  --     " \"sendKittyBellNotification(\\\"" .. session .. "\\\")\"'" ..
  " --session " .. kittyConfigDir .. "/sessions/" .. session
)
log.i("Launching tmux kitty (" .. session .. "): " .. cmd)
if not os.execute(cmd) then
  log.e("Command failed")
end
end

-- Cached application instance for default Kitty.
local defaultKittyApp

-- Returns the default Kitty application instance, or nil if it's not running.
local function getDefaultKittyApp()
  if not (defaultKittyApp and defaultKittyApp:isRunning()) then
    log.i("Refreshing default kitty cache")
    defaultKittyApp = nil
    local output = hs.execute("pgrep -lf kitty.app/Contents/MacOS/kitty")
    for line in output:gmatch('[^\r\n]+') do
      if not line:find('tmux.conf', 1, true) then
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
function sendKittyBellNotification(session)
  log.i("Sending bell notification for tmux kitty (" .. session .. ")")
  local subTitle
  if session ~= "detached" then
    subTitle = session
  end
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
    local session = choice.text
    local window = getTmuxKittyWindow(session)
    if window then
      log.i("Showing tmux kitty (" .. session .. ")")
      window:focus()
    else
      launchTmuxKitty(session)
    end
  end
  hs.chooser.new(onChoice):choices({
    {text = "localhost", subText = "tmux new -A -s 0"},
    {text = "detached"},
  }):placeholderText("Choose a session"):show()
end)
