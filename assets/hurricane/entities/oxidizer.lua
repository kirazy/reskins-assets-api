---@diagnostic disable: generic-constraint-mismatch
---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Hurricane.Entities

local _defines = require("api.defines")
local _constants = require("assets.constants")
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconCatalog = require("api.icon-catalog")

local M = {}

local check_get_graphics_set = V.signature("get_graphics_set", {
	{ "tint", Common.color:optional() },
})

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	check_get_graphics_set(tint)

	local assets_base_path = "__reskins-assets-hurricane__/graphics/entity/oxidizer/"

	---@type Animation
	local animation = {
		layers = {
			util.sprite_load(assets_base_path .. "oxidizer-base", {
				priority = "high",
				frame_count = 60,
				animation_speed = 0.5,
				scale = 0.5,
			}),
			util.sprite_load(assets_base_path .. "oxidizer-shadow", {
				priority = "high",
				draw_as_shadow = true,
				repeat_count = 60,
				scale = 0.5,
			}),
		},
	}

	if tint then
		table.insert(
			animation.layers --[[@cast-?]],
			util.sprite_load(assets_base_path .. "oxidizer-mask", {
				priority = "high",
				frame_count = 60,
				animation_speed = 0.5,
				tint = tint,
				scale = 0.5,
			})
		)
		table.insert(
			animation.layers --[[@cast-?]],
			util.sprite_load(assets_base_path .. "oxidizer-highlights", {
				priority = "high",
				frame_count = 60,
				animation_speed = 0.5,
				blend_mode = "additive-soft",
				scale = 0.5,
			})
		)
	end

	---@type CraftingMachineGraphicsSet
	return {
		animation = animation,
		status_colors = _constants.get_status_colors(),
		working_visualisations = {
			{
				fadeout = true,
				apply_recipe_tint = "primary",
				animation = util.sprite_load(assets_base_path .. "oxidizer-recipe-mask", {
					priority = "high",
					frame_count = 60,
					animation_speed = 0.5,
					tint_as_overlay = true,
					scale = 0.5,
				}),
			},
			{
				always_draw = true,
				apply_tint = "status",
				animation = util.sprite_load(assets_base_path .. "oxidizer-light", {
					priority = "high",
					frame_count = 60,
					animation_speed = 0.5,
					blend_mode = "additive",
					draw_as_glow = true,
					scale = 0.5,
				}),
			},
		},
	}
end

---@class OxidizerSpritesParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

local check_params = V.signature("get_sprite_set", {
	{
		"params",
		V.shape({
			tint = Common.color:optional(),
		}),
	},
})

---Gets the sprite set for the Hurricane oxidizer.
---@param params OxidizerSpritesParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local oxidizer = require("__reskins-assets-api__.assets.hurricane.entities.oxidizer")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = oxidizer.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws Thrown when `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_params(params)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			fluid_boxes = nil,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = nil,
			water_reflection = nil,
			nominal_width = 4,
			nominal_height = 4,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-hurricane__/graphics/icons" })

---Gets the icon for the Hurricane oxidizer, in the tints given by `params`.
M.get_icon = icons:tinted("oxidizer"):build("get_icon")

return M
