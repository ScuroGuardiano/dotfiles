HOME = os.getenv("HOME")
CONFIG_DIR = HOME .. "/.config/awesome/"

require("global_requires")
require("error_handling")
require("global_config")
require("signals")
keys = require("keys")
require("rules")

local utils = require("utils")
local topbar = require("widgets.topbar")
local tags = require("tags")

awful.screen.connect_for_each_screen(function(s)
    utils.set_wallpaper(s)
    tags(s) -- Each screen has its own tag table.
    topbar(s) -- And own topbar
end)

root.buttons(keys.buttons) -- Mouse bindings
root.keys(keys.globalkeys) -- Set keys

require("autorun")
