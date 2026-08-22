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
				filename = "__angelspetrochemgraphics__/graphics/entity/steam-cracker/steam-cracker.png",
				priority = "extra-high",
				width = 512,
				height = 512,
				scale = 0.5,
				shift = { 0.5, -0.5 },
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/steam-cracker/steam-cracker-mask.png",
			priority = "extra-high",
			width = 512,
			height = 512,
			scale = 0.5,
			shift = { 0.5, -0.5 },
			tint = tint,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/steam-cracker/steam-cracker-highlights.png",
			priority = "extra-high",
			width = 512,
			height = 512,
			scale = 0.5,
			shift = { 0.5, -0.5 },
			blend_mode = "additive-soft",
		})
	end

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			-- Flame
			{
				fadeout = true,
				constant_speed = true,
				animation = {
					filename = "__base__/graphics/entity/oil-refinery/oil-refinery-fire.png",
					line_length = 10,
					width = 40,
					height = 81,
					frame_count = 60,
					animation_speed = 0.75,
					shift = util.by_pixel(-66, -110),
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			-- Light
			{
				animation = {
					filename = "__reskins-assets-angels__/graphics/entity/steam-cracker/steam-cracker-light.png",
					priority = "extra-high",
					width = 512,
					height = 512,
					scale = 0.5,
					shift = { 0.5, -0.5 },
					blend_mode = "additive-soft",
					draw_as_glow = true,
				},
			},
		},
	}

	return graphics_set
end

---@class SteamCrackerSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's steam cracker.
---@param params SteamCrackerSpriteSetParams
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
