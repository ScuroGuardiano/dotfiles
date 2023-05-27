local FG_COLOR="#bbbbbb"
local BG_COLOR="#111111"
local HLFG_COLOR="#111111"
local HLBG_COLOR="#bbbbbb"
local BORDER_COLOR="#222222"

local ROFI_OPTIONS="-theme /home/scuroguardiano/.config/rofi/powermenu.rasi"

-- Title, command, show confirmation
local menu = {
    { "Cancel", "", false },
    { "Shutdown", "systemctl poweroff", true },
    { "Reboot", "systemctl reboot", true },
    { "Suspend", "systemctl suspend", true },
    { "Lock", "~/.config/awesome/scripts/blur-lock", false },
    { "Logout", "awesome-client \"awesome.quit()\"", true },
}

local function find_menu_item_by_key(key)
    for index, value in pairs(menu) do
        if string.find(key, value[1]) ~= nil then
            return value
        end
    end
    return nil
end

local rofi_colors = string.format(
    '-bc "%s" -bg "%s" -fg "%s" -hlfg "%s" -hlbg "%s"',
    BORDER_COLOR,
    BG_COLOR,
    FG_COLOR,
    HLFG_COLOR,
    HLBG_COLOR
)
local rofi_options = string.format(
    "-dmenu -i -lines %s %s %s -p \"\"",
    tostring(#menu),
    rofi_colors,
    ROFI_OPTIONS
)
local rofi_cmd = string.format("rofi %s", rofi_options)
local menustr = ""

for _, value in pairs(menu) do
    if menustr ~= "" then
        menustr = menustr .. "\\n"
    end
    menustr = menustr .. value[1]
end

local final_cmd = string.format('echo -e \"%s\" | %s', menustr, rofi_cmd)
local confirmation_cmd_fmt = string.format(
    'echo -e "Yes\\nNo" | rofi -dmenu -i -lines 2 -p \"%%s\" %s %s',
    rofi_colors,
    ROFI_OPTIONS
)

local function execute_action_on_menuitem(menuitem)
    local caption = menuitem[1]
    local command = menuitem[2];
    local should_confirm = menuitem[3]

    if command == "" then
        return
    end

    if should_confirm then
        awful.spawn.easy_async_with_shell(string.format(confirmation_cmd_fmt, caption .. "?"),
            function(stdout, stderr, reason, exit_code)
                if (string.find(stdout, "Yes")) then
                    awful.spawn.with_shell(command);
                end
            end
        )
        return
    end

    awful.spawn.with_shell(command);
end

local function show_powermenu()
    awful.spawn.easy_async_with_shell(final_cmd,
            function(stdout, stderr, reason, exit_code)
            local menuitem = find_menu_item_by_key(stdout)
            if menuitem ~= nil then
                execute_action_on_menuitem(menuitem)
            end
        end
    )
end

return show_powermenu