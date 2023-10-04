require('hs.ipc')

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
    hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
  end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  win:setFrame(f)
end)


function print_true_flags(flags)
  for key, value in pairs(flags) do
    if value then
      print(key)
    end
  end
end

function list_true_flags(flags)
  local true_flags = " "
  for key, value in pairs(flags) do
    if value then
      true_flags = true_flags .. key .. " | "
    end
  end
  return true_flags
end

function fileModifiedCallback(paths, flagTables)
  for i, file in ipairs(paths) do
    if file == "/Volumes/ryvault1/MacHD/Users/raymondyee/obsidian/MainRY/bike/overall.bike" then
      local flags = flagTables[i]
      print(i, file)
      print_true_flags(flags)

      local timestamp = os.date("%Y-%m-%d %H:%M:%S")
      -- local message = timestamp .. " overall.bike changed\n"

      local logFile = io.open("/tmp/hschange.log", "a")
      logFile:write(timestamp .. list_true_flags(flags) .. "\n")
      -- if (itemRenamed, itemIsFile. and itemXattrMod) are true then
      if flags.itemRenamed and flags.itemIsFile and flags.itemXattrMod then
        logFile:write("itemRenamed, itemIsFile, itemXattrMod all true\n")
        -- run a shell script
        os.execute("echo 'hello from init.lua' >> /tmp/hschange.log")
        -- os.execute("/Users/raymondyee/C/src/python-learning/bike/bike.py pandoc /Users/raymondyee/obsidian/MainRY/bike/overall.bike  /Users/raymondyee/obsidian/MainRY/bike/overall.md")
        local cmd = "/Users/raymondyee/C/src/python-learning/bike/bike.py pandoc /Users/raymondyee/obsidian/MainRY/bike/overall.bike  /Users/raymondyee/obsidian/MainRY/bike/overall.md 2>&1"
        local handle = io.popen(cmd, "r")
        local result = handle:read("*a")
        handle:close()
        logFile:write(result)
        os.execute("echo 'after bike.py pandoc....' >> /tmp/hschange.log")
      end


      logFile:close()
    end
  end
end

watcher = hs.pathwatcher.new("/Volumes/ryvault1/MacHD/Users/raymondyee/obsidian/MainRY/bike", fileModifiedCallback)
watcher:start()