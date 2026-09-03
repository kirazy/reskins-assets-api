---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

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
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's chemical furnace.
---@param params ChemicalFurnaceSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local chemical_furnace = require("__reskins-assets-api__.assets.angels.entities.smelting.chemical-furnace")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = chemical_furnace.get_sprite_set({ tint = tint })
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
			nominal_width = 5,
			nominal_height = 5,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for Angel's chemical furnace, in the given `tint`.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(tint)
	check_get_icon(tint)

	local folder = "__reskins-assets-angels__/graphics/icons/chemical-furnace/chemical-furnace-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
