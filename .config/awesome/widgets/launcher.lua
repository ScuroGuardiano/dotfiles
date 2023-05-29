local mainmenu = require("widgets.mainmenu")

return function()
    return awful.widget.launcher({
        image = beautiful.awesome_icon,
        menu = mainmenu()
    })
end
