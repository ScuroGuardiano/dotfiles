

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = keys.clientkeys,
                     buttons = keys.clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    {   -- Pavu-chan needs some special treatment UwU
        rule_any = {
            class = { "Pavucontrol" },
        },
        properties = {
            floating = true,
            width = 1000,
            height = 800,
            placement = awful.placement.centered
        }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "leagueclientux.exe"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    {
        rule_any = {
            class = {
                "Xfce4-terminal", "UXTerm"
            },
        },
        properties = {
            size_hints_honor = false
        }
    },
    {
        rule_any = {
            class = {
                "awakened-poe-trade"
            }
        },
        properties = {
            border_width = 0,
            titlebars_enabled = false,
            focus = false,
            ontop = true
        }
    }

    -- {   -- Steam is special needs kid aswell
    --     rule_any = {
    --         class = { "Steam", "awakened-poe-trade",  },
    --     },
    --     properties = {
    --         titlebars_enabled = false,
    --         border_width = 0,
    --         border_color = 0,
    --         size_hints_honor = false,
    --         floating = true
    --     }
    -- },

    -- {
    --     rule_any = {
    --         class = { "league of legends.exe", "steam_app_238960" },
    --     },
    --     properties = {
    --         titlebars_enabled = false,
    --         border_width = 0,
    --         border_color = 0
    --     }
    -- }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}