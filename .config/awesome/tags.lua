return function(s)
    local names = { "  ", " 󰈹 ", "   ", " 󰙯 ", " 5 ", " 6 ", "  ", " 8 ", " 9 " }
    local l = awful.layout.suit  -- Just to save some typing: use an alias.
    local layouts = { l.tile, l.tile, l.floating, l.tile, l.floating,
        l.floating, l.max, l.floating, l.floating }
    awful.tag(names, s, layouts)
end