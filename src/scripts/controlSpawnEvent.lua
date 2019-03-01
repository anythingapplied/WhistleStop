--serpent = require("serpent")

require("__WhistleStopFactories__.scripts.luaMacros")

-- Placing/Destroying events and loader placement

local offset1 = {[0]=1, [2]=0, [4]=-1, [6]=0}
local offset2 = {[0]=0, [2]=1, [4]=0, [6]=-1}

local function placeLoader(entity, xoffset, yoffset, type, direction)
	local xposition = entity.position.x + offset1[entity.direction] * xoffset - offset2[entity.direction] * yoffset
	local yposition = entity.position.y + offset1[entity.direction] * yoffset + offset2[entity.direction] * xoffset
	direction_final = (direction + entity.direction)%8

	local loader = entity.surface.create_entity{name="wsf-factory-loader", position={xposition, yposition}, force=entity.force, type=type, direction=direction_final}
	if loader then
		loader.destructible = false
	else
		debugWrite("Loader Spawn failed at " .. xposition .. "," .. yposition)
	end
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

local function loadersForBigAssemblyOld(entity)
	local loaderlist = global.whistlestops[entity.unit_number].loaderlist

	-- Left side loaders
	for i=-6,6 do
		if i ~= -1 then
			table.insert(loaderlist, placeLoader(entity, -7.5, i, "input", 2))
		end
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
	elseif entity.name == "wsf-big-assembly-old" then
		loadersForBigAssemblyOld(entity)
	end
end

local function destroyLoaders(unit_number)
	for k,v in pairs(global.whistlestops[unit_number].loaderlist) do
		v.destroy()
	end
	global.whistlestops[unit_number].loaderlist = {}
end

script.on_event(defines.events.on_player_rotated_entity,
	function (event)
		if inlist(event.entity.name, {"wsf-big-furnace", "wsf-big-assembly", "wsf-big-assembly-old"}) then
			destroyLoaders(event.entity.unit_number)
			if settings.global["whistle-use-loaders"].value then
				placeAllLoaders(event.entity)
			end
		end
	end
)

function on_built_event(event)
	local entity = event.created_entity
	if not inlist(entity.name, {"wsf-big-furnace", "wsf-big-assembly", "wsf-big-assembly-old", "wsf-big-refinery", "wsf-big-chemplant"}) then
		return
	end

	global.whistlestops[entity.unit_number] = {position=entity.position, type=entity.name, entity=entity, surface=entity.surface, direction=entity.direction,
		recipe=nil, tag=nil, loaderlist={}}

	if settings.global["whistle-use-loaders"].value then
		placeAllLoaders(entity)
	end

	entity.destructible = not settings.global["whistle-indestructible"].value
end

script.on_event(defines.events.on_built_entity, on_built_event)
script.on_event(defines.events.on_robot_built_entity, on_built_event)
script.on_event(defines.events.script_raised_built, on_built_event)

-- Destroying leftover loaders
function on_destroy_event(event)
	if inlist(event.entity.name, {"wsf-big-furnace", "wsf-big-assembly", "wsf-big-assembly-old", "wsf-big-refinery", "wsf-big-chemplant"}) then
		destroyLoaders(event.entity.unit_number)
		global.whistlestops[event.entity.unit_number] = nil
	end	
end

script.on_event(defines.events.on_player_mined_entity, on_destroy_event)
script.on_event(defines.events.on_robot_mined_entity, on_destroy_event)
script.on_event(defines.events.on_entity_died, on_destroy_event)
script.on_event(defines.events.script_raised_destroy, on_destroy_event)