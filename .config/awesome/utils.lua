local utils = {}
utils.focus_left_client = function()
    local c = client.focus
    if c.maximized or c.floating or c.fullscreen then
        awful.client.focus.byidx(-1)
        return
    end

    if not utils.is_client_on_direction("left") then
        awful.client.focus.byidx(-1)
        return
    end

    awful.client.focus.bydirection("left")
    client.focus:raise()
end

utils.focus_right_client = function()
    local c = client.focus
    if c.maximized or c.floating or c.fullscreen then
        awful.client.focus.byidx(1)
        return;
    end

    if not utils.is_client_on_direction("right") then
        awful.client.focus.byidx(1)
        return
    end

    awful.client.focus.bydirection("right")
    client.focus:raise()
end

utils.is_client_on_direction = function(dir, c, stacked)
    local sel = c or client.focus
    if sel then
        local cltbl = awful.client.visible(sel.screen, stacked)
        local geomtbl = {}
        for i,cl in ipairs(cltbl) do
            geomtbl[i] = cl:geometry()
        end

        local target = gears.geometry.rectangle.get_in_direction(dir, geomtbl, sel:geometry())

        return not not target
    end
end

utils.spawn_in_tagidx_and_view = function(command, tagIdx, screen)
    local screen = screen or awful.screen.focused()
    local t = screen.tags[tagIdx]
    awful.spawn.easy_async(command,
        function()
            t:view_only()
        end, {
        tag = t
    })
end

utils.trim = function (s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

return utils