-- create only single volume widget
local volume
local timer

local function update_volume()
    if volume == nil then
        return
    end
    awful.spawn.easy_async_with_shell(CONFIG_DIR .. "scripts/volume", function(out)
        volume.value = out
    end)
end

local module = {}

local levels = {
    medium = 25,
    high = 75
}

local icons = {
    mute = "󰝟",
    low = "󰕿",
    medium = "󰖀",
    high = "󰕾",
    unknown = "󰕾"
}

local function get_icon(val)
    if string.find(val, "MUTE") then
        return icons.mute
    end
    local without_percent = string.gsub(val, "%%", "")
    local numeric = tonumber(without_percent)

    if numeric == nil then
        return icons.unknown
    end

    if numeric == 0 then
        return icons.mute
    end

    if numeric >= levels.high then
        return icons.high
    end

    if numeric >= levels.medium then
        return icons.medium
    end

    return icons.low
end

local function format_value(val)
    val = string.sub(val, 1, -2) -- idk, some white character must be there
    if #val <= 2 then
        return "00" .. val
    end
    if #val <= 3 then
        return "0" .. val
    end
    return val
end

local volume_widget = function ()
    if volume ~= nil then
        return volume
    end

    volume = wibox.widget {
        markup = icons.unknown,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
        set_value = function(self, val)
            local icon = get_icon(val)
            self.markup = string.format("%s %s", icon, format_value(val))
        end
    }

    timer = gears.timer {
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

--- Insta refresh widget value
function module.refresh_value()
    if volume == nil or timer == nil then
        return
    end
    update_volume()
    timer:again()
end

setmetatable(module, {
    __call = volume_widget
})

return module