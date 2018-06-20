data:extend({



-- TECH

{
    type = "technology",
    name = "big-furnace",
    icon_size = 128,
    icon = "__base__/graphics/technology/advanced-material-processing.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "big-furnace"
      },
    },
    prerequisites = {"advanced-material-processing-2"},
    unit =
    {
      count = 250,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1}
      },
      time = 30
    },
    order = "c-c-b"
  },


-- CIRCUIT FACTORY
{
    type = "recipe",
    name = "big-furnace",
    ingredients = {{"steel-plate", 10}, {"advanced-circuit", 50}, {"electric-furnace", 20}},
    result = "big-furnace",
    energy_required = 50,
    enabled = false
  },
  
  {
    type = "item",
    name = "big-furnace",
    icon = "__TheBigFurnace__/graphics/big-furnace.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "smelting-machine",
    order = "d[big-furnace]",
    place_result = "big-furnace",
    stack_size = 50
  },
  
  {
    type = "furnace",
    name = "big-furnace",
    icon = "__TheBigFurnace__/graphics/big-furnace.png",
    icon_size = 32,
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 1, result = "big-furnace"},
    max_health = 350,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    resistances =
    {
      {
        type = "fire",
        percent = 80
      }
    },
    collision_box = {{-8.1, -8.1}, {8.1, 8.1}},
    selection_box = {{-8.8, -9}, {8.8, 9}},
    drawing_box = {{-8.8, -8.8}, {8.8, 8.8}},
    module_specification =
    {
      module_slots = 6,
      module_info_icon_shift = {0, 0.8}
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"},
    crafting_categories = {"big-smelting"},
    result_inventory_size = 2,
    crafting_speed = 40,
    energy_usage = "3600kW",
    source_inventory_size = 1,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0.005
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/electric-furnace.ogg",
        volume = 0.7
      },
      apparent_volume = 1.5
    },
    animation =
    {
      layers = {
      {
        filename = "__base__/graphics/entity/electric-furnace/electric-furnace-base.png",
        priority = "high",
        width = 129,
        height = 100,
        frame_count = 1,
        shift = {2.53125, 0},
		scale = 6,
        hr_version = {
          filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace.png",
          priority = "high",
          width = 239,
          height = 219,
          frame_count = 1,
          shift = util.by_pixel(0.75, 5.75),
          scale = 3
        }
      },
      {
        filename = "__base__/graphics/entity/electric-furnace/electric-furnace-shadow.png",
        priority = "high",
        width = 129,
        height = 100,
        frame_count = 1,
        shift = {2.53125, 0},
        draw_as_shadow = true,
		scale = 6,
        hr_version = {
          filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-shadow.png",
          priority = "high",
          width = 227,
          height = 171,
          frame_count = 1,
          draw_as_shadow = true,
          shift = util.by_pixel(11.25, 7.75),
          scale = 3
        }
      }
      }
    },
    working_visualisations =
    {
      {
        animation =
        {
          filename = "__base__/graphics/entity/electric-furnace/electric-furnace-heater.png",
          priority = "high",
          width = 0,
          height = 0,
          frame_count = 12,
          animation_speed = 0.5,
          shift = {0.015625, 0.890625},
		  scale = 6,
          hr_version = {
            filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-heater.png",
            priority = "high",
            width = 0,
            height = 0,
            frame_count = 12,
            animation_speed = 0.5,
            shift = util.by_pixel(1.75, 32.75),
            scale = 3
          }
        },
        light = {intensity = 0.4, size = 6, shift = {0.0, 1.0}, color = {r = 1.0, g = 1.0, b = 1.0}}
      },
      {
        animation =
        {
          filename = "__base__/graphics/entity/electric-furnace/electric-furnace-propeller-1.png",
          priority = "high",
          width = 0,
          height = 0,
          frame_count = 4,
          animation_speed = 0.5,
          shift = {-0.671875, -0.640625},
		  scale = 6,
          hr_version = {
            filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-propeller-1.png",
            priority = "high",
            width = 0,
            height = 0,
            frame_count = 4,
            animation_speed = 0.5,
            shift = util.by_pixel(-20.5, -18.5),
            scale = 3
          }
        }
      },
      {
        animation =
        {
          filename = "__base__/graphics/entity/electric-furnace/electric-furnace-propeller-2.png",
          priority = "high",
          width = 0,
          height = 0,
          frame_count = 4,
          animation_speed = 0.5,
          shift = {0.0625, -1.234375},
		  scale = 6,
          hr_version = {
            filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-propeller-2.png",
            priority = "high",
            width = 0,
            height = 0,
            frame_count = 4,
            animation_speed = 0.5,
            shift = util.by_pixel(3.5, -38),
            scale = 3
          }
        }
      }
    },
 --   fast_replaceable_group = "furnace"
  },
  
  {
    type = "recipe-category",
    name = "big-smelting"
  },
   
   
  -- SMELTING RECIPES 

   
   {
    type = "recipe",
    name = "big-steel-plate",
    category = "big-smelting",
    normal =
    {
      enabled = true,
      energy_required = 17.5,
      ingredients = {{"iron-plate", 100}},
      result = "steel-plate",
	  result_count = 20
    },
    expensive =
    {
      enabled = true,
      energy_required = 35.0,
      ingredients = {{"iron-plate", 100}},
      result = "steel-plate",
	  result_count = 10
    },},
	
	
	{
    type = "recipe",
    name = "big-copper-plate",
    category = "big-smelting",
    energy_required = 3.5,
    ingredients = {{ "copper-ore", 50}},
    result	= "copper-plate",
	result_count = 50
  },
  
  {
    type = "recipe",
    name = "big-iron-plate",
    category = "big-smelting",
    energy_required = 3.5,
    ingredients = {{"iron-ore", 50}},
    result = "iron-plate",
	result_count = 50
  },
  
  {
    type = "recipe",
    name = "big-stone-brick",
    category = "big-smelting",
    energy_required = 3.5,
    enabled = true,
    ingredients = {{"stone", 50}},
    result = "stone-brick",
	result_count = 25
  },
     
   
   
  
})

