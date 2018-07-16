-- Location tracking
global.whistlelocations = global.whistlelocations or {} -- Old
global.whistlestops = global.whistlestops or {} -- New

-- Migration to new location tracking
for k,v in pairs(global.whistlelocations) do
    table.insert(global.whistlestops, {})
end


-- Stat Tracking
global.whistlestats = global.whistlestats or {}
global.whistlestats["big-furnace"] = global.whistlestats["big-furnace"] or 0
global.whistlestats["big-assembly"] = global.whistlestats["big-assembly"] or 0
global.whistlestats["big-refinery"] = global.whistlestats["big-refinery"] or 0
global.whistlestats["buffer"] = global.whistlestats["buffer"] or 
    (math.max(#global.whistlelocations, #global.whistlestops) -  global.whistlestats["big-furnace"] - global.whistlestats["big-assembly"] - global.whistlestats["big-refinery"])


global.whistlelocations = nil
global.whistlestats.valid_chunk_count = nil
game.print("Whistle Stop Factories migration complete")