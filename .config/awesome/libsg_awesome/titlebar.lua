local module = {}

-- copied from https://github.com/awesomeWM/awesome/blob/db5ade48e44d393bc3dd1e967f67126696ecde98/lib/awful/titlebar.lua#L660
local function get_titlebar_function(c, position)
    if position == "left" then
        return c.titlebar_left
    elseif position == "right" then
        return c.titlebar_right
    elseif position == "top" then
        return c.titlebar_top
    elseif position == "bottom" then
        return c.titlebar_bottom
    else
        error("Invalid titlebar position '" .. position .. "'")
    end
end

--- Returns titlebar on given position
--- @param c table client
--- @param position string
--- @return table titlebar titlebar
--- @return number size size of a titlebar
function module.get_titlebar(c, position)
    return get_titlebar_function(c, position)(c);
end

--- @class TitlebarVisibilityArgs
--- @field position "top"|"bottom"|"right"|"left"? default = `top`
--- @field resize boolean? default = `false`

--- Shows titlebar on passed client, optionally resizing client
--- @param c table client on which titlebar should be shown
--- @param args TitlebarVisibilityArgs?
function module.show(c, args)
    local args = args or {}
    local position = args.position or "top"
    local resize = args.resize or false
    awful.titlebar.show(c, position)
    if resize then
        local _, size = module.get_titlebar(c, position)
        c.height = c.height - size
    end
end

--- Hides titlebar on passed client, optionally resizing client
--- @param c table client on which titlebar should be hidden
--- @param args TitlebarVisibilityArgs?
function module.hide(c, args)
    local args = args or {}
    local position = args.position or "top"
    local resize = args.resize or false
    local _, size = module.get_titlebar(c, position)
    awful.titlebar.hide(c, position)
    if resize then
        c.height = c.height + size
    end
end

--- Toggles titlebar visibility on passed client, optionally resizing client
--- @param c table client on which titlebar should be toggled
--- @param args TitlebarVisibilityArgs?
--- @return boolean visible is titlebar after toggle visible or not
function module.toggle(c, args)
    local args = args or {}
    local position = args.position or "top"
    local resize = args.resize or false
    local _, size = module.get_titlebar(c, position)
    if size == 0 then
        module.show(c, { position = position, resize = resize })
        return true
    end
    module.hide(c, { position = position, resize = resize })
    return false
end

return module
