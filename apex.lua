local Unlocker, awful, apex = ...
 
print("Apex Loaded")

awful.DevMode = true
awful.enabled = true
awful.ttd_enabled = true

-- Global Helpers --
apex.debug = true
apex.utilities = {}
apex.drawings = {}

apex.warrior = {}

apex.warrior.gui = {}
apex.warrior.settings = {}
apex.warrior.cmd = {}

apex.warrior.protection = awful.Actor:New({ spec = 3 , class = "warrior" })