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
				priority = "extra-high",
				width = 332,
				height = 374,
				frame_count = 36,
				stripes = {
					{
						filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-base_01.png",
						width_in_frames = 6,
						height_in_frames = 3,
					},
					{
						filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-base_02.png",
						width_in_frames = 6,
						height_in_frames = 3,
					},
				},
				animation_speed = 0.5,
				shift = util.by_pixel(-1, -11.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			priority = "extra-high",
			width = 332,
			height = 374,
			frame_count = 36,
			stripes = {
				{
					filename = "__reskins-assets-angels__/graphics/entity/chemical-furnace/chemical-furnace-mask-1.png",
					width_in_frames = 6,
					height_in_frames = 3,
				},
				{
					filename = "__reskins-assets-angels__/graphics/entity/chemical-furnace/chemical-furnace-mask-2.png",
					width_in_frames = 6,
					height_in_frames = 3,
				},
			},
			animation_speed = 0.5,
			tint = tint,
			shift = util.by_pixel(-1, -11.5),
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			priority = "extra-high",
			width = 332,
			height = 374,
			frame_count = 36,
			stripes = {
				{
					filename = "__reskins-assets-angels__/graphics/entity/chemical-furnace/chemical-furnace-highlights-1.png",
					width_in_frames = 6,
					height_in_frames = 3,
				},
				{
					filename = "__reskins-assets-angels__/graphics/entity/chemical-furnace/chemical-furnace-highlights-2.png",
					width_in_frames = 6,
					height_in_frames = 3,
				},
			},
			animation_speed = 0.5,
			blend_mode = "additive-soft",
			shift = util.by_pixel(-1, -11.5),
			scale = 0.5,
		})
	end

	table.insert(animation.layers--[[@cast -?]], {
		-- Shadow
		priority = "extra-high",
		width = 448,
		height = 280,
		frame_count = 36,
		stripes = {
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-shadow_01.png",
				width_in_frames = 4,
				height_in_frames = 7,
			},
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-shadow_02.png",
				width_in_frames = 4,
				height_in_frames = 2,
			},
		},
		animation_speed = 0.5,
		draw_as_shadow = true,
		shift = util.by_pixel(28, 12.5),
		scale = 0.5,
	})

	---@type CraftingMachineGraphicsSet
	local graphics_set = {
		animation = animation,
		working_visualisations = {
			{
				always_draw = true,
				animation = {
					priority = "high",
					width = 332,
					height = 374,
					frame_count = 36,
					stripes = {
						{
							filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-light_01.png",
							width_in_frames = 6,
							height_in_frames = 3,
						},
						{
							filename = "__angelssmeltinggraphics__/graphics/entity/chemical-furnace/chemical-furnace-light_02.png",
							width_in_frames = 6,
							height_in_frames = 3,
						},
					},
					animation_speed = 0.5,
					shift = util.by_pixel(-1, -11.5),
					draw_as_light = true,
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

---@class ChemicalFurnaceSpriteSetParams
---@field tint Color?

---Produces the sprite set for Angel's chemical furnace.
---@param params ChemicalFurnaceSpriteSetParams
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
