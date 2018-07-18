-- Big Furnace prototype and item definition
local create_bigfurnace = require("prototypes.bigfurnace")
create_bigfurnace("big-furnace", "8000kW", 100)

-- Big Assembly prototype and item definition
local create_bigassembly = require("prototypes.bigassembly")
create_bigassembly("big-assembly", "6000kW", 40)

-- Big Refinery prototype and item definition
local create_bigrefinery = require("prototypes.bigrefinery")
create_bigrefinery("big-refinery", "7200kW", 18)

-- Big Loader prototype and item definition
local create_bigloader = require("prototypes.bigloader")
create_bigloader("express-loader-big")