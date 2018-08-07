inspect = require("inspect")

require("luaMacros")

-- Placing/Destroying events and loader placement

local offset1 = {[0]=1, [2]=0, [4]=-1, [6]=0}
local offset2 = {[0]=0, [2]=1, [4]=0, [6]=-1}

local function placeLoader(entity, xoffset, yoffset, type, direction)
	local xposition = entity.position.x + offset1[entity.direction] * xoffset - offset2[entity.direction] * yoffset
	local yposition = entity.position.y + offset1[entity.direction] * yoffset + offset2[entity.direction] * xoffset
	direction_final = (direction + entity.direction)%8

	local loader = entity.surface.create_entity{name="wsf-factory-loader", position={xposition, yposition}, force=entity.force, type=type, direction=direction_final}
	loader.destructible = false
	return loader
end

local function loadersForBigFurnace(entity)
	local loaderlist = global.whistlestops[entity.unit_number].loaderlist
	
	for i=2,5 do
		-- Left side loaders
		table.insert(loaderlist, placeLoader(entity, -7.5, i, "input", 2))
		table.insert(loaderlist, placeLoader(entity, -7.5, -i, "input", 2))
		-- Right side loaders
		table.insert(loaderlist, placeLoader(entity, 7.5, i, "output", 2))
		table.insert(loaderlist, placeLoader(entity, 7.5, -i, "output", 2))
	end
end

local function loadersForBigAssembly(entity)
	local loaderlist = global.whistlestops[entity.unit_number].loaderlist

	-- Left side loaders
	for i=1,6 do
		table.insert(loaderlist, placeLoader(entity, -7.5, i, "input", 2))
		table.insert(loaderlist, placeLoader(entity, -7.5, -i, "input", 2))
	end

	-- Right side loaders
	for i=2,5 do
		table.insert(loaderlist, placeLoader(entity, 7.5, i, "output", 2))
		table.insert(loaderlist, placeLoader(entity, 7.5, -i, "output", 2))
	end

	for i=2,6 do
		-- Bottom loaders
		table.insert(loaderlist, placeLoader(entity, -i, 7.5, "input", 0))
		-- Top loaders
		table.insert(loaderlist, placeLoader(entity, -i, -7.5, "input", 4))
	end
end

local function placeAllLoaders(entity)
	if entity.name == "wsf-big-furnace" then
		loadersForBigFurnace(entity)
	elseif entity.name == "wsf-big-assembly" then
		loadersForBigAssembly(entity)
	end
end

local function placeBeacon(entity)
	local beacon
	if entity.name == "wsf-big-refinery" then
		beacon = entity.surface.create_entity{name="wsf-beacon-2", position=entity.position, force=entity.force}
	else
		beacon = entity.surface.create_entity{name="wsf-beacon-1", position=entity.position, force=entity.force}
	end

	if global.speed_tech_level then
		beacon.get_module_inventory().insert{name="wsf-speed-module", count=global.speed_tech_level}
	end
	
	global.whistlestops[entity.unit_number].beacon = beacon
end

local function destroyLoaders(unit_number)
	for k,v in pairs(global.whistlestops[unit_number].loaderlist) do
		v.destroy()
	end
	global.whistlestops[unit_number].loaderlist = {}
end

local function destroyBeacon(unit_number)
	global.whistlestops[unit_number].beacon.destroy()
	global.whistlestops[unit_number].beacon = nil
end

script.on_event(defines.events.on_player_rotated_entity,
	function (event)
		if event.entity.name == "wsf-big-furnace" or event.entity.name == "wsf-big-assembly" then
			destroyLoaders(event.entity.unit_number)
			placeAllLoaders(event.entity)
		end
	end
)

local function on_built_event(event)
	local entity = event.created_entity
	if not inlist(entity.name, {"wsf-big-furnace", "wsf-big-assembly", "wsf-big-refinery", "wsf-big-chemplant"}) then
		return
	end

	global.whistlestops[entity.unit_number] = {position=entity.position, type=entity.name, entity=entity, surface=entity.surface, direction=entity.direction,
		recipe=nil, tag=nil, loaderlist={}, beacon=nil}

	placeAllLoaders(entity)
	placeBeacon(entity)
end

script.on_event(defines.events.on_built_entity, on_built_event)
script.on_event(defines.events.on_robot_built_entity, on_built_event)
script.on_event(defines.events.script_raised_built, on_built_event)

-- Destroying leftover loaders and beacons
local function on_destroy_event(event)
	if inlist(event.entity.name, {"wsf-big-furnace", "wsf-big-assembly", "wsf-big-refinery", "wsf-big-chemplant"}) then
		destroyLoaders(entity.unit_number)
		destroyBeacon(entity.unit_number)
	end	
end

script.on_event(defines.events.on_player_mined_entity, on_destroy_event)
script.on_event(defines.events.on_robot_mined_entity, on_destroy_event)
script.on_event(defines.events.on_entity_died, on_destroy_event)
script.on_event(defines.events.script_raised_destroy, on_destroy_event)