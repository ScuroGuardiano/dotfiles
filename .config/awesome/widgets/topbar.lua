local volume_widget = require("widgets.volume")
local clock = require("widgets.clock")
local taglist = require("widgets.taglist")
local tasklist = require("widgets.tasklist")
local prompt = require("widgets.prompt")
local layoutbox = require("widgets.layoutbox")

return function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = layoutbox(s)

    -- Create a taglist widget
    s.mytaglist = taglist(s)

    -- Create a tasklist widget
    s.mytasklist = tasklist(s)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    s.volume = volume_widget()

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
              -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist,     -- Middle widget
        {
                          -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            s.volume,
            clock(),
            s.mylayoutbox,
        },
    }
end
