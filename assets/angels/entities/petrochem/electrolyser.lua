---cspell: words Electrolyser
---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

local entity_horizontal_base = {
	filename = "__angelspetrochemgraphics__/graphics/entity/electrolyser/electrolyser-east.png",
	width = 224,
	height = 224,
	frame_count = 36,
	line_length = 6,
	shift = { 0, 0 },
	animation_speed = 0.5,
}

local entity_vertical_base = {
	filename = "__angelspetrochemgraphics__/graphics/entity/electrolyser/electrolyser-north.png",
	priority = "extra-high",
	width = 224,
	height = 224,
	frame_count = 36,
	line_length = 6,
	shift = { 0, 0 },
	animation_speed = 0.5,
}

local pipe_pictures = {
	north = util.empty_sprite(),
	east = util.empty_sprite(),
	south = {
		filename = "__angelspetrochemgraphics__/graphics/entity/electrolyser/pipe-south.png",
		priority = "extra-high",
		width = 41,
		height = 40,
		shift = util.by_pixel(5, -8),
	},
	west = util.empty_sprite(),
}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		north = { layers = { entity_vertical_base } },
		east = { layers = { entity_horizontal_base } },
		south = { layers = { entity_vertical_base } },
		west = { layers = { entity_horizontal_base } },
	}

	if tint then
		local entity_mask = {
			filename = "__reskins-assets-angels__/graphics/entity/electrolyser/electrolyser-mask.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
			tint = tint,
		}
		local entity_highlights = {
			filename = "__reskins-assets-angels__/graphics/entity/electrolyser/electrolyser-highlights.png",
			priority = "extra-high",
			width = 224,
			height = 224,
			frame_count = 36,
			line_length = 6,
			shift = { 0, 0 },
			animation_speed = 0.5,
			blend_mode = "additive-soft",
		}
		table.insert(animation.north.layers--[[@cast -?]], entity_mask)
		table.insert(animation.north.layers--[[@cast -?]], entity_highlights)
		table.insert(animation.east.layers--[[@cast -?]], entity_mask)
		table.insert(animation.east.layers--[[@cast -?]], entity_highlights)
		table.insert(animation.south.layers--[[@cast -?]], entity_mask)
		table.insert(animation.south.layers--[[@cast -?]], entity_highlights)
		table.insert(animation.west.layers--[[@cast -?]], entity_mask)
		table.insert(animation.west.layers--[[@cast -?]], entity_highlights)
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {},
	}

	return graphics_set
end

---@class ElectrolyserSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's electrolyser.
---@param params ElectrolyserSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local electrolyser = require("__reskins-assets-api__.assets.angels.entities.petrochem.electrolyser")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = electrolyser.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	---@type FluidBoxGraphics
	local fluid_box = {
		pipe_picture = pipe_pictures,
	}

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = get_graphics_set(params.tint),
			fluid_boxes = { fluid_box },
			fluid_boxes_off_when_no_fluid_recipe = false,
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

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for Angel's electrolyser, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/electrolyser/electrolyser-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
