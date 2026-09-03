---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

---@param tint Color?
---@return RotatedSprite
local function get_pictures(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/substation/"

	---@type RotatedSprite
	local pictures = {
		layers = {
			{
				filename = assets_path .. "substation-base.png",
				priority = "high",
				width = 138,
				height = 270,
				direction_count = 4,
				shift = util.by_pixel(0, -31),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(pictures.layers--[[@cast -?]], {
			filename = assets_path .. "substation-mask.png",
			priority = "high",
			width = 138,
			height = 270,
			direction_count = 4,
			shift = util.by_pixel(0, -31),
			tint = tint,
			scale = 0.5,
		})
		table.insert(pictures.layers--[[@cast -?]], {
			filename = assets_path .. "substation-highlights.png",
			priority = "high",
			width = 138,
			height = 270,
			direction_count = 4,
			shift = util.by_pixel(0, -31),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	table.insert(pictures.layers--[[@cast -?]], {
		filename = assets_path .. "substation-shadow.png",
		priority = "high",
		width = 370,
		height = 104,
		direction_count = 4,
		shift = util.by_pixel(62, 10),
		draw_as_shadow = true,
		scale = 0.5,
	})

	return pictures
end

---@param tint Color?
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/substation/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = assets_path .. "substation-remnants.png",
				width = 182,
				height = 134,
				direction_count = 1,
				shift = util.by_pixel(2.5, 0.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "substation-remnants-mask.png",
			width = 182,
			height = 134,
			direction_count = 1,
			shift = util.by_pixel(2.5, 0.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. "substation-remnants-highlights.png",
			width = 182,
			height = 134,
			direction_count = 1,
			shift = util.by_pixel(2.5, 0.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation }
end

---@class SubstationSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for the vanilla substation.
---@param params SubstationSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<ElectricPoleSpriteSet>
---
---#### Examples
---```lua
---local substation = require("__reskins-assets-api__.assets.base.entities.substation")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = substation.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type SpriteSetDefinition<ElectricPoleSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.electric_pole_sprite_set,
		set = {
			pictures = get_pictures(params.tint),
			corpse_overlay = nil,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = nil,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla substation, in the tints given by `params`.
M.get_icon = icons:tinted("substation"):build("get_icon")

return M
