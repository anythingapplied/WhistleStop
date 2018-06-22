data:extend({

  -- Big furnace item definition
  {
    type = "item",
    name = "big-furnace",
    icon = "__WhistleStopFactories__/graphics/icons/big-furnace.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "smelting-machine",
    order = "d[big-furnace]",
    place_result = "big-furnace",
    stack_size = 50
  },

-- Big furnace entity definition
  {
    type = "furnace",
    name = "big-furnace",
    icon = "__WhistleStopFactories__/graphics/icons/big-furnace.png",
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
    crafting_speed = 100,
    energy_usage = "2000kW",
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
		    scale = 5.4,
        hr_version = {
          filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace.png",
          priority = "high",
          width = 239,
          height = 219,
          frame_count = 1,
          shift = util.by_pixel(0.75, 5.75),
          scale = 2.7
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
		    scale = 5.4,
        hr_version = {
          filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-shadow.png",
          priority = "high",
          width = 227,
          height = 171,
          frame_count = 1,
          draw_as_shadow = true,
          shift = util.by_pixel(11.25, 7.75),
          scale = 2.7
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
		      scale = 5.4,
          hr_version = {
            filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-heater.png",
            priority = "high",
            width = 0,
            height = 0,
            frame_count = 12,
            animation_speed = 0.5,
            shift = util.by_pixel(1.75, 32.75),
            scale = 2.7
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
		      scale = 5.4,
          hr_version = {
            filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-propeller-1.png",
            priority = "high",
            width = 0,
            height = 0,
            frame_count = 4,
            animation_speed = 0.5,
            shift = util.by_pixel(-20.5, -18.5),
            scale = 2.7
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
		      scale = 5.4,
          hr_version = {
            filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-propeller-2.png",
            priority = "high",
            width = 0,
            height = 0,
            frame_count = 4,
            animation_speed = 0.5,
            shift = util.by_pixel(3.5, -38),
            scale = 2.7
          }
        }
      }
    },
  },
  
  -- Big furnace recipe category
  {
    type = "recipe-category",
    name = "big-smelting"
  },
   
  -- Big assembly item definition
  {
    type = "item",
    name = "big-assembly",
    icon = "__WhistleStopFactories__/graphics/icons/big-assembly.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "production-machine",
    order = "c[big-assembling-machine]",
    place_result = "big-assembly",
    stack_size = 50
  },

  -- Big assembly entity definition
    
    {
      type = "assembling-machine",
      name = "big-assembly",
      icon = "__WhistleStopFactories__/graphics/icons/big-assembly.png",
      icon_size = 32,
      flags = {"placeable-neutral","placeable-player", "player-creation"},
      minable = {hardness = 0.2, mining_time = 0.5, result = "big-assembly"},
      max_health = 400,
      corpse = "big-remnants",
      dying_explosion = "big-explosion",
      alert_icon_shift = util.by_pixel(-3, -12),
      resistances =
      {
        {
          type = "fire",
          percent = 70
        }
      },
      fluid_boxes = {
        {
            production_type = "input",
            pipe_picture = assembler3pipepictures(),
            pipe_covers = pipecoverspictures(),
            base_area = 10,
            base_level = -1,
            pipe_connections = {{ type="input", position = {1, -9} }},
            secondary_draw_orders = { north = -1 }
        },
        {
            production_type = "input",
            pipe_picture = assembler3pipepictures(),
            pipe_covers = pipecoverspictures(),
            base_area = 10,
            base_level = -1,
            pipe_connections = {{ type="input", position = {-9, -1} }},
            secondary_draw_orders = { north = -1 }
        },
        {
            production_type = "output",
            pipe_picture = assembler3pipepictures(),
            pipe_covers = pipecoverspictures(),
            base_area = 10,
            base_level = 1,
            pipe_connections = {{ type="output", position = {9, 1} }},
            secondary_draw_orders = { north = -1 }
        },
        {
            production_type = "output",
            pipe_picture = assembler3pipepictures(),
            pipe_covers = pipecoverspictures(),
            base_area = 10,
            base_level = 1,
            pipe_connections = {{ type="output", position = {-1, 9} }},
            secondary_draw_orders = { north = -1 }
        },
        off_when_no_fluid_recipe = true
        },
      open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
      close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
      vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
      working_sound =
      {
        sound = {
          {
            filename = "__base__/sound/assembling-machine-t3-1.ogg",
            volume = 0.8
          },
          {
            filename = "__base__/sound/assembling-machine-t3-2.ogg",
            volume = 0.8
          },
        },
        idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
        apparent_volume = 1.5,
      },
      collision_box = {{-8.1, -8.1}, {8.1, 8.1}},
      selection_box = {{-8.8, -9}, {8.8, 9}},
      drawing_box = {{-8.8, -8.8}, {8.8, 8.8}},
      animation =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/assembling-machine-3/assembling-machine-3.png",
            priority = "high",
            width = 108,
            height = 119,
            frame_count = 32,
            line_length = 8,
            shift = util.by_pixel(0, -0.5),
            scale = 6,
            hr_version = {
              filename = "__base__/graphics/entity/assembling-machine-3/hr-assembling-machine-3.png",
              priority = "high",
              width = 214,
              height = 237,
              frame_count = 32,
              line_length = 8,
              shift = util.by_pixel(0, -0.75),
              scale = 3
            }
          },
          {
            filename = "__base__/graphics/entity/assembling-machine-3/assembling-machine-3-shadow.png",
            priority = "high",
            width = 130,
            height = 82,
            frame_count = 32,
            line_length = 8,
            scale = 6,
            draw_as_shadow = true,
            shift = util.by_pixel(28, 4),
            hr_version = {
              filename = "__base__/graphics/entity/assembling-machine-3/hr-assembling-machine-3-shadow.png",
              priority = "high",
              width = 260,
              height = 162,
              frame_count = 32,
              line_length = 8,
              draw_as_shadow = true,
              shift = util.by_pixel(28, 4),
              scale = 3
            }
          },
        },
      },
  
      crafting_categories = {"big-recipe"},
      crafting_speed = 40,
      energy_source =
      {
        type = "electric",
        usage_priority = "secondary-input",
        emissions = 0.03 / 3.5
      },
      energy_usage = "1500kW",
      ingredient_count = 10,
      module_specification =
      {
        module_slots = 5
      },
      allowed_effects = {"consumption", "speed", "productivity", "pollution"}
    },
  -- Big assembly recipe category
  {
    type = "recipe-category",
    name = "big-recipe"
  },

  })