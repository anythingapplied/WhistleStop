-- Sets a goal proportion for buildings.  Figures out how many of each building you'd need
-- with 100 more buildings on the map to match that goal, and uses ratios of the amounts
-- of each building required to fulfill that goal as the distribution of possible buildings.
-- Also, has intial offsets, so some buildings either appear to already be on their way to
-- the goal and will spawn less initially (with positive boost) or start with a negative
-- boost to give them a higher likelyhood, but only initially.

building_list = {"buffer", "big-furnace", "big-assembly", "big-refinery"}
-- The ideal propotions of different kinds of machine for end game
local goal_proportion = {}
goal_proportion["buffer"] = 30
goal_proportion["big-furnace"] = 35
goal_proportion["big-assembly"] = 35
goal_proportion["big-refinery"] = 2

-- Offsets to trick the game into thinking your starting amounts of machines are at certain levels.
-- Higher numbers will push spawning off until more factories are discovered, negative numbers will spawn more earlier
local initial_boost = {}
initial_boost["buffer"] = 0
initial_boost["big-furnace"] = 0
initial_boost["big-assembly"] = -30
initial_boost["big-refinery"] = 2

-- Calculate sums of all sets of points for probability calculation
local total_proportion = 0
local total_boost = 0
for k,v in pairs(building_list) do
    total_proportion = total_proportion + goal_proportion[v]
    total_boost = total_boost + initial_boost[v]
end

local function chooseNextSpawnType()
    if global.whistlestats["big-furnace"] < 2 then  -- First two spawns will be furnances, for convience
        return "big-furnace"
    end
    
    -- Calculate sums of all sets of points for probability calculation
    local total_historical = 0
    for k,v in pairs(building_list) do
        total_historical = total_historical + global.whistlestats[v]
    end

    -- Tries to make sure you'll have exactly you're ideal target by the time you hit goal_target number of machines
    -- and uses the distribution of what would need to be spawned between now and then as your probability of spawning each
    local goal_target = (total_historical + total_boost) + 100
    local adjusted_probability = {}
    local adjusted_probability_total = 0
    for k,v in pairs(building_list) do
        adjusted_probability[v] = math.max(0, goal_target * goal_proportion[v] / total_proportion - global.whistlestats[v] - initial_boost[v])
        adjusted_probability_total = adjusted_probability_total + adjusted_probability[v]
    end
    
    local selection_var = math.random()
    local selection_var_orig = selection_var
    for k,v in pairs(building_list) do
        selection_var = selection_var - adjusted_probability[v]/adjusted_probability_total
        if selection_var <= 0 then
            return v
        end
    end
    log()
    return "buffer"
end

return chooseNextSpawnType