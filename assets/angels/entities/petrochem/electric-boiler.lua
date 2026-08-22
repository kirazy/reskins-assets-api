---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local _sprites = require("__reskins-sprite-utils__.sprites")

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
---@field tint Color?

---Produces the sprite set for Angel's electric boiler.
---@param params ElectricBoilerSpriteSetParams
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---@nodiscard
function M.get(params)
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

return M
