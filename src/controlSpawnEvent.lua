local function on_built_entity(entity)
    local ce = entity.surface.create_entity 
    local fN = entity.force
	local center = entity.position
	local loaders

	if entity.name == "big-furnace" then
		for i=-5,-2 do
			-- Left side loaders
			loaders = ce{name = "express-loader", position = {center.x + (-7.5), center.y + (i)}, force = fN,type = "input", direction = 2}
			loaders.destructible = false
			loaders.minable = false
			-- Right side loaders
			loaders = ce{name = "express-loader", position = {center.x + (7), center.y + (i)}, force = fN,type = "output", direction = 2}
			loaders.destructible = false
			loaders.minable = false
		end
		for i=2,5 do
			-- Left side loaders
			loaders = ce{name = "express-loader", position = {center.x + (-7.5), center.y + (i)}, force = fN,type = "input", direction = 2}
			loaders.destructible = false
			loaders.minable = false
			-- Right side loaders
			loaders = ce{name = "express-loader", position = {center.x + (7), center.y + (i)}, force = fN,type = "output", direction = 2}
			loaders.destructible = false
			loaders.minable = false
		end
	elseif entity.name == "big-assembly" then
		-- LEFT
		for i=-6,6 do
			if i ~= -1 then
				loaders = ce{name = "express-loader", position = {center.x + (-7.5), center.y + (i)}, force = fN,type = "input", direction = 2}
				loaders.destructible = false
				loaders.minable = false
			end
		end
		
		-- RIGHT
		for i=2,5 do
			loaders = ce{name = "express-loader", position = {center.x + (7), center.y + (i)}, force = fN,type = "output", direction = 2}
			loaders.destructible = false
			loaders.minable = false
			loaders = ce{name = "express-loader", position = {center.x + (7), center.y + (-i)}, force = fN,type = "output", direction = 2}
			loaders.destructible = false
			loaders.minable = false
		end

		-- BOTTOM
		for i=-6,-2 do
			-- BOTTOM
			loaders = ce{name = "express-loader", position = {center.x + (i), center.y + (7.5)}, force = fN,type = "input"}
			loaders.destructible = false
			loaders.minable = false
			-- TOP
			loaders = ce{name = "express-loader", position = {center.x + (i), center.y + (-8)}, force = fN,type = "input", direction = 4}
			loaders.destructible = false
			loaders.minable = false
		end
	end
end

-- Building a big assembly machine
local function on_built_event(event)
	if event.created_entity.name == "big-furnace" or event.created_entity.name == "big-assembly" then
		on_built_entity(event.created_entity)
	end
end

script.on_event(defines.events.on_built_entity, on_built_event)
script.on_event(defines.events.on_robot_built_entity, on_built_event)
script.on_event(defines.events.script_raised_built, on_built_event)

-- Destroying a big assembly machine
local function on_destroy_event(event)
	if event.entity.name == "big-furnace" or event.entity.name == "big-assembly" then
		local center = event.entity.position
		local area = {{center.x-8.8, center.y-8.8}, {center.x+8.8, center.y+8.8}}
		for _, entity in pairs(event.entity.surface.find_entities_filtered{area=area, name="express-loader"}) do
			entity.destroy()
		end
	end	
end

script.on_event(defines.events.on_player_mined_entity, on_destroy_event)
script.on_event(defines.events.on_robot_mined_entity, on_destroy_event)
script.on_event(defines.events.on_entity_died, on_destroy_event)
script.on_event(defines.events.script_raised_destroy, on_destroy_event)