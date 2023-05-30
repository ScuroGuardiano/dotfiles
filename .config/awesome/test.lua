local json = require("lib.json")
local data = io.read("*a")
local parsed = json.decode(data)
print(100 - tonumber(parsed.sysstat.hosts[1].statistics[1]["cpu-load"][1].idle))