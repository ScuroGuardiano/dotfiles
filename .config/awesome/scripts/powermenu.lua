#!/usr/bin/env lua

local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local FG_COLOR="#bbbbbb"
local BG_COLOR="#111111"
local HLFG_COLOR="#111111"
local HLBG_COLOR="#bbbbbb"
local BORDER_COLOR="#222222"

local ROFI_OPTIONS="-theme /home/scuroguardiano/.config/rofi/powermenu.rasi"

-- Title, command, show confirmation
local menu = {
    [" Cancel"] = { "", true },
    [" Shutdown"] = { "systemctl poweroff", true },
    [" Reboot"] = { "systemctl reboot", true },
    [" Suspend"] = { "systemctl suspend", true },
    [" Lock"] = { "~/.config/awesome/scripts/blur-lock", true },
    [" Logout"] = { "awesome-client \"awesome.quit()\"", true },
}

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
local roficmd = string.format("rofi %s", rofi_options)
local menustr = ""

for key, value in pairs(menu) do
    if menustr ~= "" then
        menustr = menustr .. "\\n"
    end
    menustr = menustr .. key
end

local finalcmd = string.format('bash -c "echo $(echo -e \"%s\" | %s)"', menustr, roficmd)
local selection = os.execute(finalcmd)
-- local command = menu[selection]