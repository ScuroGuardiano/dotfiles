local cpu_widget;

local colors = {
    low = beautiful.moonlight.teal,
    moderate = beautiful.moonlight.teal,
    high = beautiful.moonlight.yellow,
    heavy = beautiful.moonlight.dark_red,
    unknown = beautiful.moonlight.red
}

local levels = {
    moderate = 25,
    high = 75,
    heavy = 90
}

local icon = ""

local function parse_cpu_usage(str)
    local parsed = json.decode(str)
    return 100 - tonumber(parsed.sysstat.hosts[1].statistics[1]["cpu-load"][1].idle)
end

local function read_cpu_usage(callback)
    awful.spawn.easy_async_with_shell("mpstat 1 1 -o JSON", function (out)
        local status, val = pcall(parse_cpu_usage, out)
        if status then
            return callback(val)
        end
        return callback(nil)
    end)
end

local function format_value(val)
    if val == nil then
        return "ERR"
    end

    return string.format("%03.0f", val)
end

local function get_color(val)
    if val == nil then
        return colors.unknown
    end

    if val >= levels.heavy then
        return colors.heavy
    end

    if val >= levels.high then
        return colors.high
    end

    if val >= levels.moderate then
        return colors.moderate
    end

    return colors.low
end

--- CPU usage widget
return function()
    if cpu_widget ~= nil then
        return cpu_widget
    end

    local cpu_usage_format = string.format("<span foreground='%%s'>%s %%s%%%%</span>", icon)

    cpu_widget = wibox.widget {
        markup = string.format(cpu_usage_format, colors.unknown, "???"),
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
        set_value = function(self, val)
            local color = get_color(val);
            self.markup = string.format(cpu_usage_format, color, format_value(val))
        end
    }

    local function update_value(val)
        cpu_widget.value = val

        -- mpstat 1 1 needs one second to return.
        -- so to read usage every one second I just need to call read_cpu_usage again
        read_cpu_usage(update_value)
    end

    read_cpu_usage(update_value)

    return cpu_widget
end