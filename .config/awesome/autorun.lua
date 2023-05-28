-- beep disable (really, beeps are terrible)
awful.spawn.once("xset b off", awful.rules.rules)

-- caps fix
awful.spawn.once(HOME .. "/capsfix.sh")

-- picom --config  ~/.config/picom.conf
awful.spawn.once("picom --config " .. HOME .. "/.config/picom.conf")
