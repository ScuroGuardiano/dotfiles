local keys = {}
local mod = modkey
local shift = "Shift"
local ctrl = "Control"

local utils = require("utils")
local powermenu = require("menus.powermenu")
local volume_widget = require("widgets.volume")
local mainmenu = require("widgets.mainmenu")

local tags = 9

-- {{{ I don't like to write a lot in my config file ;)

-- With Modkey
local function wm(key, fn, options)
    return awful.key({ mod }, key, fn, options)
end

-- With Modkey + Shift
local function wms(key, fn, options)
    return awful.key({ mod, shift }, key, fn, options);
end

-- With Modkey + Control
local function wmc(key, fn, options)
    return awful.key({ mod, ctrl }, key, fn, options);
end

-- With Modkey + Shift + Control
local function wmsc(key, fn, options)
    return awful.key({ mod, shift, ctrl }, key, fn, options);
end

keys.tags = tags
keys.buttons = gears.table.join(
    awful.button({  }, 3, function() mainmenu():toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)
-- }}}

keys.globalkeys = gears.table.join(
    -- System
    wm("l",
        function () awful.spawn(CONFIG_DIR .. "/scripts/blur-lock") end,
        { description = "Lock screen", group = "System" }
    ),

    wm("s",
        hotkeys_popup.show_help,
        { description="show help", group="awesome" }
    ),
    wmc("Left",
        awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),
    wmc("Right",
        awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),
    wm("Escape",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),

    wm("Left",
        utils.focus_left_client,
        { description = "focus client on the left", group = "client"}
    ),
    wm("Right",
        utils.focus_right_client,
        { description = "focus client on the right", group = "client"}
    ),
    wm("Down",
        function() awful.client.focus.bydirection("down") end,
        { description = "focus client below", group = "client"}
    ),
    wm("Up",
        function() awful.client.focus.bydirection("up") end,
        { description = "focus client above", group = "client"}
    ),

    wm("j",
        function () awful.client.focus.byidx( 1) end,
        { description = "focus next by index", group = "client" }
    ),
    wm("k",
        function () awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }
    ),
    -- wm("w",
    --     function () mymainmenu:show() end,
    --     { description = "show main menu", group = "awesome" }
    -- ),

    -- Layout manipulation
    wms("j",
        function () awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }
    ),
    wms("k",
        function () awful.client.swap.byidx( -1) end,
        { description = "swap with previous client by index", group = "client" }
    ),
    wmc("j",
        function () awful.screen.focus_relative( 1) end,
        { description = "focus the next screen", group = "screen" }
    ),
    wmc("k",
        function () awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }
    ),
    wm("u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),
    wm("Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),

    -- Standard program
    wm("Return",
        function () awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }
    ),
    wm("w",
        function ()
            utils.spawn_in_tagidx_and_view("firefox", 2)
        end,
        { description = "open firefox", group = "launcher" }
    ),
    wms("g",
        function()
            utils.spawn_in_tagidx_and_view("steam", 3)
        end,
        { description = "open steam, G like GAMING", group = "launcher" }
    ),
    wms("p",
        function()
            utils.spawn_in_tagidx_and_view("steam steam://rungameid/238960", 3)
        end,
        { description = "I NEED TO PLAY POE RIGHT NOW", group = "launcher" }
    ),

    wms("r",
        awesome.restart,
        { dscription = "reload awesome", group = "awesome" }
    ),
    wms("q",
        awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),

    -- wm("l",
    --     function () awful.tag.incmwfact( 0.05) end,
    --     { description = "increase master width factor", group = "layout" }
    -- ),
    -- wm("h",
    --     function () awful.tag.incmwfact(-0.05) end,
    --     { description = "decrease master width factor", group = "layout" }
    -- ),
    -- wms("h",
    --     function () awful.tag.incnmaster( 1, nil, true) end,
    --     { description = "increase the number of master clients", group = "layout" }
    -- ),
    -- wms("l",
    --     function () awful.tag.incnmaster(-1, nil, true) end,
    --     { description = "decrease the number of master clients", group = "layout" }
    -- ),
    -- wmc("h",
    --     function () awful.tag.incncol( 1, nil, true) end,
    --     { description = "increase the number of columns", group = "layout" }
    -- ),
    -- wmc("l",
    --     function () awful.tag.incncol(-1, nil, true) end,
    --     { description = "decrease the number of columns", group = "layout" }
    -- ),
    wm("space",
        function () awful.layout.inc( 1) end,
        { description = "select next", group = "layout" }
    ),
    wms("space", function () awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }
    ),

    wmc("n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end,
        { description = "restore minimized", group = "client" }
    ),

    -- Prompt
    wm("r",
        function () awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }
    ),

    wm("x",
        function ()
            awful.prompt.run {
                prompt = "Run Lua code: ",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }
    ),
    -- Menus
    -- This is cool... well awful actually ;3 I'd use rofi instead.
    -- wm("p",
    --     function() menubar.show() end,
    --     { description = "show the menubar", group = "launcher" }
    -- ),
    wms("e",
        powermenu,
        -- function() awful.spawn.with_shell(CONFIG_DIR .. "scripts/powermenu") end,
        { description = "open power menu", group = "launcher" }
    ),
    wm("d",
        function()
            awful.spawn("rofi -modi drun -show drun -config " .. HOME .. "/.config/rofi/rofidmenu.rasi")
        end,
        { description = "open dmenu", group = "launcher" }
    ),
    wm("t",
        function()
            awful.spawn("rofi -show window -config " .. HOME .. "/.config/rofi/rofidmenu.rasi")
        end,
        { description = "open dmenu", group = "launcher" }
    ),

    -- Screenshots
    awful.key({ }, "Print",
        function()
            awful.spawn.with_shell("scrot --silent -e 'xclip -selection clipboard -t image/png -i $f' && notify-send \"Scweenshwot sawed to clipbwoard! UwU\"")
        end,
        { description = "Take full screen screenshot", group = "Screenshots" }
    ),
    wms("s",
        function()
            awful.spawn.with_shell("scrot --silent -s -f -e 'xclip -selection clipboard -t image/png -i $f' && notify-send \"Scweenshwot sawed to clipbwoard! UwU\"")
        end,
        { description = "Screenshot of selected part of screen", group = "Screenshots" }
    ),

    -- audio
    wm("p",
        function ()
            awful.spawn.with_shell(CONFIG_DIR .. "scripts/audio-device-switch.sh")
        end,
        { description = "Switch audio device", group = "audio" }
    ),
    awful.key({ }, "XF86AudioRaiseVolume",
        function()
            awful.spawn.easy_async_with_shell("exec amixer -D pulse sset Master 2%+", function()
                volume_widget.refresh_value()
            end)
        end,
        { description = "Increase volume by 2%", group = "audio" }
    ),
    awful.key({ }, "XF86AudioLowerVolume",
        function()
            awful.spawn.easy_async_with_shell("exec amixer -D pulse sset Master 2%-", function ()
                volume_widget.refresh_value()
            end)
        end,
        { description = "Decrease volume by 2%", group = "audio" }
    ),
    awful.key({ }, "XF86AudioMute",
        function()
            awful.spawn.easy_async_with_shell("exec amixer sset Master toggle", function ()
                volume_widget.refresh_value()
            end)
        end,
        { description = "Toggle mute", group = "audio" }
    ),
    -- My keyboard have only play
    awful.key({ }, "XF86AudioPlay",
        function()
            awful.spawn.with_shell("playerctl play-pause")
        end,
        { description = "Play", group = "audio" }
    ),
    -- awful.key({ }, "XF86AudioPause",
    --     function()
    --         awful.spawn.with_shell("playerctl pause")
    --     end,
    --     { description = "Pause", group = "audio" }
    -- ),
    awful.key({ }, "XF86AudioNext",
        function()
            awful.spawn.with_shell("playerctl next")
        end,
        { description = "Next", group = "audio" }
    ),
    awful.key({ }, "XF86AudioPrev",
        function()
            awful.spawn.with_shell("playerctl previous")
        end,
        { description = "Previous", group = "audio" }
    )
    
)

keys.clientkeys = gears.table.join(
    wm("v",
        function (c)
            libsg.titlebar.toggle(c, { position = "top", resize = true })
        end
    ),
    wm("f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),
    wm("q",
        function (c) c:kill() end,
        { description = "quit", group = "client" }
    ),
    wmc("space",
        awful.client.floating.toggle                     ,
        { description = "toggle floating", group = "client" }
    ),
    wmc("Return",
        function (c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }
    ),
    wm("o",
        function (c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    wm("t",
        function (c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }
    ),
    wm("n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        { description = "minimize", group = "client" }
    ),
    wm("m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }
    ),
    wmc("m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        { description = "(un)maximize vertically", group = "client" }
    ),
    wms("m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        { description = "(un)maximize horizontally", group = "client" }
    )
)

keys.clientbuttons = gears.table.join(
    -- Activate with left mouse click
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),

    -- Move with Mod + left mouse hold
    awful.button({ mod }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),

    -- Resize with Mod + right mouse hold
    awful.button({ mod }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- View tag only.
        wm("#" .. i + 9,
            function ()
                  local screen = awful.screen.focused()
                  local tag = screen.tags[i]
                  if tag then
                     tag:view_only()
                  end
            end,
            { description = "view tag #"..i, group = "tag" }
        ),
        -- Toggle tag display.
        wmc("#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "show windows from tag #" .. i, group = "tag" }
        ),
        -- Move client to tag.
        wms("#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
               end
            end,
            { description = "move focused client to tag #"..i, group = "tag" }
        ),
        -- Toggle tag on focused client.
        wmsc("#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "stick focused client to tag #" .. i, group = "tag" }
        )
    )
end

return keys