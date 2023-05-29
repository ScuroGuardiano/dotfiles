local mainmenu

return function()
    if mainmenu ~= nil then
        return mainmenu
    end

    local myawesomemenu = {
        { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
        { "manual",      terminal .. " -e man awesome" },
        { "edit config", editor_cmd .. " " .. awesome.conffile },
        { "restart",     awesome.restart },
        { "quit",        function() awesome.quit() end },
    }

    mainmenu = awful.menu({
        items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
            { "open terminal", terminal }
        }
    })

    return mainmenu
end
