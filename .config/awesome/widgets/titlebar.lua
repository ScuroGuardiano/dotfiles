local titlebar_layout = require("layouts.titlebar_layout")

return function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    local titlebar = awful.titlebar(c, { font = beautiful.titlebar_font })
    local titlewidget = awful.titlebar.widget.titlewidget(c);
    titlewidget.font = beautiful.titlebar_font

    local titlebar_top_layer = {
      {
        -- Left
          awful.titlebar.widget.iconwidget(c),
          buttons = buttons,
          layout  = wibox.layout.fixed.horizontal
      },
      {
            -- Middle
          {
            -- Title
              align  = "center",
              widget = titlewidget
          },
          buttons = buttons,
          layout  = wibox.layout.flex.horizontal
      },
      {
        -- Right
          awful.titlebar.widget.floatingbutton(c),
          awful.titlebar.widget.maximizedbutton(c),
          awful.titlebar.widget.stickybutton(c),
          awful.titlebar.widget.ontopbutton(c),
          awful.titlebar.widget.closebutton(c),
          layout = wibox.layout.fixed.horizontal,
      },
      layout = titlebar_layout.horizontal,
    }
    -- FIXME: this titlebar doesn't work correctly, can't drag it until I do it on titletext
    -- FIXME: must figure out the way to make titletext appear centered while expaning it's widget

    titlebar:setup {
      layout = wibox.layout.stack,
      {
        layout = wibox.layout.align.horizontal(),
        -- buttons = buttons
      },
      titlebar_top_layer
    }

    return titlebar
end
