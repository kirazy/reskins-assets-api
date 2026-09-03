---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

-- Setup inheritance.

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/oil-refinery/"

	---@type Animation[]
	local layers = {
		-- Base
		{
			filename = "__base__/graphics/entity/oil-refinery/oil-refinery.png",
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

	-- Shadow
	table.insert(layers, {
		filename = "__base__/graphics/entity/oil-refinery/oil-refinery-shadow.png",
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

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/oil-refinery/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = "__base__/graphics/entity/oil-refinery/remnants/refinery-remnants.png",
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

---@class OilRefinerySpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for the vanilla oil refinery.
---@param params OilRefinerySpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local oil_refinery = require("__reskins-assets-api__.assets.base.entities.oil-refinery")
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

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for the vanilla oil refinery, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-base__/graphics/icons/oil-refinery/oil-refinery-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
