-- beep disable (really, beeps are terrible)
awful.spawn.once("xset b off", awful.rules.rules)

-- caps fix
awful.spawn.once(HOME .. "/capsfix.sh")


