-- Big Furnace prototype and item definition
local create_bigfurnace = require("prototypes.bigfurnace")
-- name, energy_consumption, crafting_speed
create_bigfurnace("wsf-big-furnace", "8000kW", 100)

-- Big Assembly prototype and item definition
local create_bigassembly = require("prototypes.bigassembly")
-- name, energy_consumption, crafting_speed
create_bigassembly("wsf-big-assembly", "6000kW", 40)

-- Big Refinery prototype and item definition
local create_bigrefinery = require("prototypes.bigrefinery")
-- name, energy_consumption, crafting_speed
create_bigrefinery("wsf-big-refinery", "7200kW", 18)

-- Big Chemical Plant prototype and item definition
-- local create_bigchemplant = require("prototypes.bigchemplant")
-- create_bigchemplant("wsf-big-chemplant", "7200kW", 18)

local create_bigbeacon = require("prototypes.bigbeacon")
-- name, collision_box
create_bigbeacon("wsf-beacon-1", {{-8.1, -8.1}, {8.1, 8.1}})
create_bigbeacon("wsf-beacon-2", {{-14.1, -14.1}, {14.1, 14.1}})  -- For big refinery sized buildings