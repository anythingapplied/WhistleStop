inspect = require("inspect")
-- Placing/Destroying events and loader placement

local function placeLoader(entity, xoffset, yoffset, type, direction)
	local ce = entity.surface.create_entity 
	local fN = entity.force
	local position = {entity.position.x + xoffset, entity.position.y + yoffset}

	local loader = ce{name="express-loader-big", position=position, force=fN, type=type, direction=direction}
	global.whistlestops[entity].loaders[loader] = {x=xoffset, y=yoffset, direction=direction}
end

local offset1 = {1, 0, -1, 0}
local offset2 = {0, 1, 0, -1}

script.on_event(defines.events.on_player_rotated_entity,
	function (event)
		local entity = event.entity
		log(entity.name)
		log(inspect(entity.position))
		for k,v in pairs(global.whistlestops) do
			if math.abs(v.position.x - entity.position.x) < 10 and math.abs(v.position.y - entity.position.y) < 10 then
				log(tostring(k))
				log(k.name)
				log(v.name)
				log(inspect(v.position))
			end
			if v.entity == event.entity then
				log("FOUND IT!")
			end
		end
		game.print(inspect(global.whistlestops))
		for loader, offsets in pairs(global.whistlestops[entity].loaders) do
			local xposition = entity.position.x + offset1[entity.direction] * offsets.x + offset2[entity.direction] * offsets.y
			local yposition = entity.position.y + offset1[entity.direction] * offsets.y + offset2[entity.direction] * offsets.x
			loader.telport({xposition, yposition})
			loader.direction = (entity.direction + offsets.direction - 1) % 4 + 1
		end
	end
)

function on_built_event(event)
	local entity = event.created_entity
	local center = entity.position

	if entity.name == "big-furnace" then
		for i=2,5 do
			-- Left side loaders
			placeLoader(entity, -7.5, i, "input", 2)
			placeLoader(entity, -7.5, -i, "input", 2)
			-- Right side loaders
			placeLoader(entity, 7, i, "output", 2)
			placeLoader(entity, 7, -i, "output", 2)
		end
	elseif entity.name == "big-assembly" then
		-- Left side loaders
		for i=-6,6 do
			if i ~= -1 then
				placeLoader(entity, -7.5, i, "input", 2)
			end
		end
		
		-- Right side loaders
		for i=2,5 do
			placeLoader(entity, 7, i, "output", 2)
			placeLoader(entity, 7, -i, "output", 2)
		end

		for i=-6,-2 do
			-- Bottom loaders
			placeLoader(entity, i, 7.5, "input", 1)
			-- Top loaders
			placeLoader(entity, i, -8, "input", 4)
		end
	end
end

script.on_event(defines.events.on_built_entity, on_built_event)
script.on_event(defines.events.on_robot_built_entity, on_built_event)
script.on_event(defines.events.script_raised_built, on_built_event)

-- Removed the loaders
function clean_up(surface, center)
	debugWrite("Cleaning up big factory loaders at " .. center.x .. "," .. center.y)
	local area = {{center.x-8.8, center.y-8.8}, {center.x+8.8, center.y+8.8}}
	for _, entity in pairs(surface.find_entities_filtered{area=area, name="express-loader"}) do
		if not entity.destructible and not entity.minable then
			entity.destroy()
		end
	end
end

-- Destroying a big assembly machine
local function on_destroy_event(event)
	if event.entity.name == "big-furnace" or event.entity.name == "big-assembly" then
		clean_up(event.entity.surface, event.entity.position)
	end	
end

script.on_event(defines.events.on_player_mined_entity, on_destroy_event)
script.on_event(defines.events.on_robot_mined_entity, on_destroy_event)
script.on_event(defines.events.on_entity_died, on_destroy_event)
script.on_event(defines.events.script_raised_destroy, on_destroy_event)