---@diagnostic disable: generic-constraint-mismatch
---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local IconCatalog = require("api.icon-catalog")

local M = {}

local assets_induction_furnace = "__reskins-assets-angels__/graphics/entity/induction-furnace/"
local smelting_induction_furnace = "__angelssmeltinggraphics__/graphics/entity/induction-furnace/"

local pipe_direction_names = {
	[defines.direction.north] = "north",
	[defines.direction.east] = "east",
	[defines.direction.south] = "south",
	[defines.direction.west] = "west",
}

---@param state "connected"|"capped"
---@param direction defines.direction
---@param is_flipped boolean
---@return Animation
local function get_pipe_picture(state, direction, is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""
	local direction_str = pipe_direction_names[direction] or "north"

	local base_path = smelting_induction_furnace .. "induction-furnace-pipe-" .. state .. "-" .. direction_str
	---@type Animation
	local animation = {
		layers = {
			util.sprite_load(base_path .. flipped, {
				priority = "high",
				scale = 0.5,
			}),
			util.sprite_load(base_path .. "-shadow" .. flipped, {
				priority = "high",
				draw_as_shadow = true,
				scale = 0.5,
			}),
		},
	}

	return animation
end

-- Shadow patch positions are fixed screen-space offsets tuned to the geometry of the induction
-- furnace's pipe connection point at {2, -2} in north-facing design space. The flipped orientation
-- doesn't mirror cleanly — it only has a shadow on its west side, not north — so this is a direct
-- lookup rather than a derived one.
local pipe_shadows = {
	[false] = {
		[defines.direction.north] = _pipes.vertical_pipe_shadow({ 2, -2 }),
		[defines.direction.west] = _pipes.horizontal_pipe_shadow({ -2, -2 }),
	},
	[true] = {
		[defines.direction.west] = _pipes.horizontal_pipe_shadow({ -2, 2 }),
	},
}

---@param direction defines.direction
---@param is_flipped boolean
---@return Animation?
local function get_pipe_shadow(direction, is_flipped)
	return pipe_shadows[is_flipped == true][direction]
end

---@param is_flipped boolean?
---@return Animation
local function get_base_animation(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type Animation
	local animation = {
		layers = {
			util.sprite_load(smelting_induction_furnace .. "induction-furnace-base" .. flipped, {
				priority = "high",
				scale = 0.5,
			}),
			util.sprite_load(smelting_induction_furnace .. "induction-furnace-base-shadow" .. flipped, {
				priority = "high",
				draw_as_shadow = true,
				scale = 0.5,
			}),
		},
	}

	return animation
end

---@param is_flipped boolean?
---@return WorkingVisualisation
local function get_integration_patch_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	local working_vis = {
		always_draw = true,
		render_layer = "floor",
		animation = util.sprite_load(smelting_induction_furnace .. "induction-furnace-integration-patch" .. flipped, {
			priority = "high",
			scale = 0.5,
		}),
	}

	return working_vis
end

---@param is_flipped boolean?
---@return WorkingVisualisation
local function get_idle_animation_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type WorkingVisualisation
	local working_vis = {
		always_draw = true,
		animation = {
			layers = {
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-idle-animation" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					scale = 0.5,
				}),
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-animation-shadow" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					draw_as_shadow = true,
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---@param is_flipped boolean?
---@return WorkingVisualisation
local function get_animation_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type WorkingVisualisation
	local working_vis = {
		fadeout = true,
		animation = {
			layers = {
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-animation" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---@param is_flipped boolean?
---@return WorkingVisualisation
local function get_recipe_mask_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type WorkingVisualisation
	local working_vis = {
		always_draw = true,
		apply_recipe_tint = "primary",
		animation = {
			layers = {
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-lower-recipe-mask" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					scale = 0.5,
				}),
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-upper-recipe-mask" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---@param is_flipped boolean?
---@return WorkingVisualisation
local function get_lights_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type WorkingVisualisation
	local working_vis = {
		always_draw = true,
		animation = {
			layers = {
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-lights" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					draw_as_light = true,
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---@param is_flipped boolean?
---@return WorkingVisualisation
local function get_working_lights_working_vis(is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	---@type WorkingVisualisation
	local working_vis = {
		fadeout = true,
		animation = {
			layers = {
				util.sprite_load(smelting_induction_furnace .. "induction-furnace-working-lights" .. flipped, {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					draw_as_light = true,
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---@param tint Color?
---@param is_flipped boolean?
---@return WorkingVisualisation?
local function get_color_mask_working_vis(tint, is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""

	local working_vis = {
		always_draw = true,
		animation = {
			layers = {
				util.sprite_load(assets_induction_furnace .. "induction-furnace" .. flipped .. "-mask", {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					tint = tint,
					scale = 0.5,
				}),
				util.sprite_load(assets_induction_furnace .. "induction-furnace" .. flipped .. "-highlights", {
					priority = "high",
					frame_count = 36,
					animation_speed = 0.5,
					blend_mode = "additive-soft",
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

local function get_graphics_set_internal(tint, is_flipped)
	local working_visualisations = {
		get_integration_patch_working_vis(is_flipped),
		get_idle_animation_working_vis(is_flipped),
		get_animation_working_vis(is_flipped),
		get_recipe_mask_working_vis(is_flipped),
		get_lights_working_vis(is_flipped),
		get_working_lights_working_vis(is_flipped),
	}

	if tint then
		table.insert(working_visualisations, get_color_mask_working_vis(tint, is_flipped))
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = get_base_animation(is_flipped),
		working_visualisations = working_visualisations,
	}

	return graphics_set
end

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	return get_graphics_set_internal(tint, false)
end

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set_flipped(tint)
	return get_graphics_set_internal(tint, true)
end

---@class InductionFurnaceSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's induction furnace.
---@param params InductionFurnaceSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local induction_furnace = require("__reskins-assets-api__.assets.angels.entities.smelting.induction-furnace")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = induction_furnace.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	local graphics_set = get_graphics_set(params.tint)
	local graphics_set_flipped = get_graphics_set_flipped(params.tint)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = graphics_set,
			graphics_set_flipped = graphics_set_flipped,
			working_visualisation_pipe_connectors = {
				get_picture = get_pipe_picture,
				get_shadow = get_pipe_shadow,
				behind_directions = { defines.direction.north, defines.direction.west },
				front_directions = { defines.direction.east, defines.direction.south },
			},
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = nil,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's induction furnace, in the tints given by `params`.
M.get_icon = icons:tinted("induction-furnace"):build("get_icon")

return M
