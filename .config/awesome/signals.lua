local utils = require("utils")
local titlebar = require("widgets.titlebar")

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", utils.set_wallpaper)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if c.class == "awakened-poe-trade" then
        gears.timer.delayed_call(function()
            c.ontop = true
        end)
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    if c.requests_no_titlebar then
        return
    end

    titlebar(c)
end)

--Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if c.class == "awakened-poe-trade" then
        return
    end

    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)


client.connect_signal("focus", function(c)
    -- naughty.notify { text = string.format("%s : %s, %s", c.class, tostring(c.ontop), tostring(c.hidded)) }
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        libsg.titlebar.hide(c, { resize = true })
        gears.timer.delayed_call(function()
            if c.valid then
              c:geometry(c.screen.geometry)
            end
        end)
    elseif not c.requests_no_titlebar then
        libsg.titlebar.show(c, { resize = true })
    end
  end)

client.connect_signal("property::ontop", function(c)
    if c.class == "awakened-poe-trade" and not c.ontop then
        gears.timer.delayed_call(function() c.ontop = true end)
    end
end)

client.connect_signal("property::request_no_titlebar", function(c)
    if c.request_no_titlebar then
        awful.titlebar.hide(c)
    else
        awful.titlebar.show(c)
    end
end)
