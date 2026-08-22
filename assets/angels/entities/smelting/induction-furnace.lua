---@diagnostic disable: generic-constraint-mismatch
---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local M = {}

local assets_induction_furnace = "__reskins-assets-angels__/graphics/entity/induction-furnace/"
local smelting_induction_furnace = "__angelssmeltinggraphics__/graphics/entity/induction-furnace/"

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
---@field tint Color?

---Produces the sprite set for Angel's induction furnace.
---
---FIXME: the old pack also built per-rotation pipe corner working visualisations from the
---prototype's own fluid box connection directions, in its `apply_to_entity`. That reads the
---prototype, so it can't live in a producer; it needs to move into the crafting-machine
---applicator before this entity's pipes render again. See
---`graphics-packs/angels/smelting/induction-furnace-graphics-pack.lua` for the original logic.
---@param params InductionFurnaceSpriteSetParams
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---@nodiscard
function M.get(params)
	local graphics_set = get_graphics_set(params.tint)
	local graphics_set_flipped = get_graphics_set_flipped(params.tint)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = graphics_set,
			graphics_set_flipped = graphics_set_flipped,
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

return M
