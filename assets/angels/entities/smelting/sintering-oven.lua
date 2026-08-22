---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/sintering-oven/sintering-oven-base.png",
				priority = "extra-high",
				width = 326,
				height = 350,
				shift = util.by_pixel(-1, -6.5),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/sintering-oven/sintering-oven-shadow.png",
				priority = "extra-high",
				width = 424,
				height = 227,
				shift = util.by_pixel(23, 28),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/sintering-oven/sintering-oven-mask.png",
			priority = "extra-high",
			width = 326,
			height = 350,
			shift = util.by_pixel(-1, -6.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/sintering-oven/sintering-oven-highlights.png",
			priority = "extra-high",
			width = 326,
			height = 350,
			shift = util.by_pixel(-1, -6.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				fadeout = true,
				effect = "uranium-glow",
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/sintering-oven/sintering-oven-glow.png",
					priority = "high",
					width = 326,
					height = 350,
					blend_mode = "additive",
					shift = util.by_pixel(-1, -6.5),
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				fadeout = true,
				effect = "uranium-glow",
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/sintering-oven/sintering-oven-light.png",
					priority = "high",
					width = 326,
					height = 350,
					shift = util.by_pixel(-1, -6.5),
					draw_as_light = true,
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

---@class SinteringOvenSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's sintering oven.
---@param params SinteringOvenSpriteSetParams
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
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

return M
