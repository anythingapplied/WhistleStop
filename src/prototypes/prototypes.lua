-- Big Furnace prototype and item definition
local create_bigfurnace = require("prototypes.bigfurnace")
-- name, energy_consumption, crafting_speed
create_bigfurnace("big-furnace", "8000kW", 100)

-- Big Assembly prototype and item definition
local create_bigassembly = require("prototypes.bigassembly")
-- name, energy_consumption, crafting_speed
create_bigassembly("big-assembly", "6000kW", 40)

-- Big Refinery prototype and item definition
local create_bigrefinery = require("prototypes.bigrefinery")
-- name, energy_consumption, crafting_speed
create_bigrefinery("big-refinery", "7200kW", 18)

-- Big Chemical Plant prototype and item definition
-- local create_bigchemplant = require("prototypes.bigchemplant")
-- create_bigchemplant("big-chemplant", "7200kW", 18)

local create_bigbeacon = require("prototypes.bigbeacon")
-- name, collision_box
create_bigbeacon("big-beacon-1", {{-8.1, -8.1}, {8.1, 8.1}})
create_bigbeacon("big-beacon-2", {{-14.1, -14.1}, {14.1, 14.1}})  -- For refinery sized buildings