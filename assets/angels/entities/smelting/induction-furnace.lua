---@diagnostic disable: generic-constraint-mismatch
---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconBuilderFactory = require("api.icon-builder-factory")
local OilRefineryExplosion = require("assets.base.explosions.oil-refinery")

local M = {}

local assets_induction_furnace = "__reskins-assets-angels__/graphics/entity/induction-furnace/"
local smelting_induction_furnace = "__angelssmeltinggraphics__/graphics/entity/induction-furnace/"

local pipe_direction_names = {
	[defines.direction.north] = "north",
	[defines.direction.east] = "east",
	[defines.direction.south] = "south",
	[defines.direction.west] = "west",
}

---Gets the pipe connector artwork of Angel's induction furnace in the given `state`, for the given `direction`.
---@param state "connected"|"capped"
---@param direction defines.direction
---@param is_flipped boolean
---@return Animation
local function get_pipe_picture(state, direction, is_flipped)
	local flipped = is_flipped == true and "-flipped" or ""
	local direction_str = pipe_direction_names[direction] or "north"

	local name = "induction-furnace-pipe-" .. state .. "-" .. direction_str
	---@type Animation
	local animation = {
		layers = {
			util.sprite_load(smelting_induction_furnace .. name .. flipped, {
				priority = "high",
				scale = 0.5,
			}),
			util.sprite_load(smelting_induction_furnace .. name .. "-shadow" .. flipped, {
				priority = "high",
				draw_as_shadow = true,
				scale = 0.5,
			}),
		},
	}

	return animation
end

---Gets the shadow patch of Angel's induction furnace for the pipe connected in the given `direction`, if any.
---@param direction defines.direction
---@param is_flipped boolean
---@return Animation?
local function get_pipe_shadow(direction, is_flipped)
	-- Shadow patch positions are fixed screen-space offsets tuned to the geometry of the induction
	-- furnace's pipe connection point at {2, -2} in north-facing design space. The flipped orientation
	-- has a shadow on its west side only, so the positions are looked up directly.
	local pipe_shadows = {
		[false] = {
			[defines.direction.north] = _pipes.vertical_pipe_shadow({ 2, -2 }),
			[defines.direction.west] = _pipes.horizontal_pipe_shadow({ -2, -2 }),
		},
		[true] = {
			[defines.direction.west] = _pipes.horizontal_pipe_shadow({ -2, 2 }),
		},
	}

	return pipe_shadows[is_flipped == true][direction]
end

---Gets the pipe connector artwork of Angel's induction furnace.
---@return WorkingVisualisationPipeConnectors
local function get_pipe_connectors()
	return {
		get_picture = get_pipe_picture,
		get_shadow = get_pipe_shadow,
		behind_directions = { defines.direction.north, defines.direction.west },
		front_directions = { defines.direction.east, defines.direction.south },
	}
end

---Gets the animation of the body of Angel's induction furnace.
---@param is_flipped? boolean
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

---Gets the working visualisation of Angel's induction furnace that draws the integration patch.
---@param is_flipped? boolean
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

---Gets the working visualisation of Angel's induction furnace that draws the idle animation and its shadow.
---@param is_flipped? boolean
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

---Gets the working visualisation of Angel's induction furnace that draws the working animation.
---@param is_flipped? boolean
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

---Gets the working visualisation of Angel's induction furnace that draws the recipe masks.
---@param is_flipped? boolean
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

---Gets the working visualisation of Angel's induction furnace that draws the lights.
---@param is_flipped? boolean
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

---Gets the working visualisation of Angel's induction furnace that draws the lights while it is working.
---@param is_flipped? boolean
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

---Gets the working visualisation of Angel's induction furnace that draws the mask in the given `tint`, and the
---highlights.
---@param tint Color
---@param is_flipped? boolean
---@return WorkingVisualisation
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
					blend_mode = "additive",
					scale = 0.5,
				}),
			},
		},
	}

	return working_vis
end

---Gets the graphics set of Angel's induction furnace.
---@param tint? Color
---@param is_flipped boolean
---@return CraftingMachineGraphicsSet
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

---Gets the graphics set of Angel's induction furnace when it is not flipped.
---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	return get_graphics_set_internal(tint, false)
end

---Gets the graphics set of Angel's induction furnace when it is flipped.
---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set_flipped(tint)
	return get_graphics_set_internal(tint, true)
end

---Gets the circuit connector of Angel's induction furnace for each direction.
---@return [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_vector(universal_connector_template, {
		{
			variation = 5,
			main_offset = util.by_pixel(-32.75, -14.5),
			shadow_offset = util.by_pixel(-32.75, -14.5),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(-32.75, -14.5),
			shadow_offset = util.by_pixel(-32.75, -14.5),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(-32.75, -14.5),
			shadow_offset = util.by_pixel(-32.75, -14.5),
			show_shadow = true,
		},
		{
			variation = 5,
			main_offset = util.by_pixel(-32.75, -14.5),
			shadow_offset = util.by_pixel(-32.75, -14.5),
			show_shadow = true,
		},
	})
end

---Defines the options for the Angel's induction furnace sprite set.
---@class InductionFurnaceSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("InductionFurnaceSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for Angel's induction furnace.
---@param params InductionFurnaceSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for Angel's induction furnace.
---
---#### Examples
---```lua
---local induction_furnace = require("__reskins-assets-api__.assets.angels.entities.smelting.induction-furnace")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = induction_furnace.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			graphics_set_flipped = get_graphics_set_flipped(params.tint),
			working_visualisation_pipe_connectors = get_pipe_connectors(),
			circuit_connector = get_circuit_connector(),
			use_mirroring = true,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = OilRefineryExplosion.get_explosion({
				tints = params.tint and {
					["oil-refinery-metal-particle-big-tint"] = params.tint,
					["oil-refinery-metal-particle-medium"] = params.tint,
				},
			}),
			corpse = _defines.generic_remnants,
			water_reflection = nil,
			drawing_box_vertical_extension = 0.5,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-angels__/graphics/icons" })

local icon_builder = icons:tinted("induction-furnace")

---Gets the icon for Angel's induction furnace, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for Angel's induction furnace as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
