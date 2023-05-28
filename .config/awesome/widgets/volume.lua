return function (s)
    local volume = wibox.widget {
        screen = s,
        markup = "<b>VOLUME</b>",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
        set_value = function(self, val)
            self.markup = string.format("<b>VOLUME: %s</b>", val)
        end
    }

    local function update_volume()
        awful.spawn.easy_async_with_shell(CONFIG_DIR .. "scripts/volume", function(out)
            volume.value = out
        end)
    end

    local timer = gears.timer {
        timeout = 1,
        call_now = true,
        autostart = true,
        callback = update_volume
    }

    volume:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.spawn("pavucontrol") end),
        awful.button({ }, 3, function ()
            awful.spawn("amixer sset Master toggle")
            update_volume()
            timer:again()
        end),
        awful.button({ }, 4, function ()
            awful.spawn.with_shell("amixer -D pulse sset Master 2%+")
            update_volume()
            timer:again()
        end),
        awful.button({ }, 5, function ()
            awful.spawn.with_shell("amixer -D pulse sset Master 2%-")
            update_volume()
            timer:again()
        end)
    ))


    return volume;
end
