---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

-- Setup inheritance.

---@param tint? Color
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local assets_path = _defines.assets_source.assorted_assets .. "/graphics/entity/oil-refinery-original/"

	---@type Animation[]
	local layers = {
		{
			filename = assets_path .. "oil-refinery-base.png",
			priority = "high",
			width = 386,
			height = 430,
			shift = util.by_pixel(0, -7.5),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. "oil-refinery-mask.png",
			priority = "high",
			width = 386,
			height = 430,
			shift = util.by_pixel(0, -7.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. "oil-refinery-highlights.png",
			priority = "high",
			width = 386,
			height = 430,
			shift = util.by_pixel(0, -7.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(layers, {
		filename = assets_path .. "oil-refinery-shadow.png",
		width = 674,
		height = 426,
		shift = util.by_pixel(82.5, 26.5),
		draw_as_shadow = true,
		scale = 0.5,
	})

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }) --[[@as Animation4Way]],
	}

	return graphics_set
end

---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.assorted_assets .. "/graphics/entity/oil-refinery-original/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = assets_path .. "oil-refinery-remnants-base.png",
				width = 467,
				height = 415,
				direction_count = 1,
				shift = util.by_pixel(-0.25, -0.25),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "oil-refinery-remnants-mask.png",
			width = 467,
			height = 415,
			direction_count = 1,
			shift = util.by_pixel(-0.25, -0.25),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "oil-refinery-remnants-highlights.png",
			width = 467,
			height = 415,
			direction_count = 1,
			shift = util.by_pixel(-0.25, -0.25),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return animation
end

---Defines the options for the original oil refinery sprite set.
---@class OilRefinerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

---Gets the sprite set for the original oil refinery.
---@param params OilRefinerySpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for the original oil refinery.
---
---#### Examples
---```lua
---local oil_refinery = require("__reskins-assets-api__.assets.assorted.entities.oil-refinery-original")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = oil_refinery.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla oil refinery, in the tints given by `params`.
M.get_icon = icons:tinted("oil-refinery"):build("get_icon")

return M
