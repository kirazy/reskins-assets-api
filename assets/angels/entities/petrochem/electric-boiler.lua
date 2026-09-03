---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")
local IconCatalog = require("api.icon-catalog")

local M = {}

---@type Animation4Way
local working_lights = _sprites.make_4way_animation_from_spritesheet({
	filename = "__reskins-assets-angels__/graphics/entity/boiler-electric/boiler-electric-working-lights.png",
	priority = "extra-high",
	width = 160,
	height = 160,
	shift = { 0, 0 },
	blend_mode = "additive",
	draw_as_glow = true,
})--[[@as Animation4Way]]

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local layers = {
		-- Base
		{
			filename = "__reskins-assets-angels__/graphics/entity/boiler-electric/boiler-electric-base.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
		},
	}

	if tint then
		table.insert(layers, {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/boiler-electric/boiler-electric-mask.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			tint = tint,
		})
		table.insert(layers, {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/boiler-electric/boiler-electric-highlights.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			shift = { 0, 0 },
			blend_mode = "additive-soft",
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }) --[[@as Animation4Way]],
		working_visualisations = {
			{
				fadeout = true,
				effect = "uranium-glow",
				north_animation = working_lights.north,
				east_animation = working_lights.east,
				south_animation = working_lights.south,
				west_animation = working_lights.west,
			},
		},
	}

	return graphics_set
end

---@class ElectricBoilerSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's electric boiler.
---@param params ElectricBoilerSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local electric_boiler = require("__reskins-assets-api__.assets.angels.entities.petrochem.electric-boiler")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = electric_boiler.get_sprite_set({ tint = tint })
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
			corpse = nil,
			water_reflection = nil,
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's electric boiler, in the tints given by `params`.
M.get_icon = icons:tinted("boiler-electric"):build("get_icon")

return M
