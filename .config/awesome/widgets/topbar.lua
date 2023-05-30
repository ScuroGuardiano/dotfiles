local volume_widget = require("widgets.volume")
local cpu_usage = require("widgets.cpu_usage")
local clock = require("widgets.clock")
local taglist = require("widgets.taglist")
local tasklist = require("widgets.tasklist")
local prompt = require("widgets.prompt")
local layoutbox = require("widgets.layoutbox")

return function(s)
    s.mywibox = awful.wibar({ position = "top", screen = s })
    -- Create a promptbox for each screen
    s.mywibox.mypromptbox = prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mywibox.mylayoutbox = layoutbox(s)

    -- Create a taglist widget
    s.mywibox.mytaglist = taglist(s)

    -- Create a tasklist widget
    s.mywibox.mytasklist = tasklist(s)

    -- Create the wibox

    s.mywibox.volume = volume_widget {
        color = beautiful.moonlight.blue
    }

    s.mywibox.cpu_usage = cpu_usage()

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mywibox.mytaglist,
            s.mywibox.mypromptbox,
            -- s.mywibox.mytasklist
        },
        {
            align = "center",
            widget = clock()
        },
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = 16,
            s.mywibox.cpu_usage,
            s.mywibox.volume,
            wibox.widget.systray(),
            s.mywibox.mylayoutbox,
        },
    }
end
