-- Big Furnace prototype and item definition
local create_bigfurnace = require("prototypes.bigfurnace")
create_bigfurnace("big-furnace", "8000kW", 100)

-- Big Assembly prototype and item definition
local create_bigassembly = require("prototypes.bigassembly")
create_bigassembly("big-assembly", "6000kW", 40)

-- Big Refinery prototype and item definition
local create_bigrefinery = require("prototypes.bigrefinery")
create_bigrefinery("big-refinery", "7200kW", 18)

-- Big Chemical Plant prototype and item definition
local create_bigchemplant = require("prototypes.bigchemplant") -- TEMP
create_bigchemplant("big-chemplant", "7200kW", 18)

inspect = require("inspect")
log(inspect(data.raw["assembling-machine"]["chemical-plant"]))
log(inspect(data.raw["assembling-machine"]["big-chemplant"]))