---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Angels.Entities

local _defines = require("api.defines")
local IconCatalog = require("api.icon-catalog")

local M = {}

---@param tint Color?
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint)
	local animation = {
		layers = {
			-- Base
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/blast-furnace/blast-furnace-base.png",
				priority = "extra-high",
				width = 328,
				height = 376,
				shift = util.by_pixel(0, -13.5),
				scale = 0.5,
			},
			-- Shadow
			{
				filename = "__angelssmeltinggraphics__/graphics/entity/blast-furnace/blast-furnace-shadow.png",
				priority = "extra-high",
				width = 445,
				height = 245,
				shift = util.by_pixel(29, 19.5),
				draw_as_shadow = true,
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			-- Mask
			filename = "__reskins-assets-angels__/graphics/entity/blast-furnace/blast-furnace-mask.png",
			priority = "extra-high",
			width = 328,
			height = 376,
			shift = util.by_pixel(0, -13.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			-- Highlights
			filename = "__reskins-assets-angels__/graphics/entity/blast-furnace/blast-furnace-highlights.png",
			priority = "extra-high",
			width = 328,
			height = 376,
			shift = util.by_pixel(0, -13.5),
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
				north_position = { 0, 0 },
				east_position = { 0, 0 },
				south_position = { 0, 0 },
				west_position = { 0, 0 },
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/blast-furnace/blast-furnace-fire.png",
					priority = "high",
					width = 23,
					height = 50,
					line_length = 8,
					frame_count = 48,
					animation_speed = 0.5,
					shift = util.by_pixel(3, 29),
					draw_as_glow = true,
					scale = 0.5,
				},
			},
			{
				fadeout = true,
				north_position = { 0, 0 },
				east_position = { 0, 0 },
				south_position = { 0, 0 },
				west_position = { 0, 0 },
				effect = "flicker",
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/blast-furnace/blast-furnace-glow.png",
					priority = "high",
					width = 60,
					height = 43,
					blend_mode = "additive",
					shift = util.by_pixel(5, 39),
					draw_as_glow = true,
					scale = 0.75,
				},
			},
			{
				fadeout = true,
				north_position = { 0, 0 },
				east_position = { 0, 0 },
				south_position = { 0, 0 },
				west_position = { 0, 0 },
				effect = "flicker",
				animation = {
					filename = "__angelssmeltinggraphics__/graphics/entity/blast-furnace/blast-furnace-working-light.png",
					priority = "high",
					width = 328,
					height = 376,
					blend_mode = "additive",
					shift = util.by_pixel(0, -13.5),
					draw_as_glow = true,
					scale = 0.5,
				},
			},
		},
	}

	return graphics_set
end

---@class BlastFurnaceSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?

---Gets the sprite set for Angel's blast furnace.
---@param params BlastFurnaceSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local blast_furnace = require("__reskins-assets-api__.assets.angels.entities.smelting.blast-furnace")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = blast_furnace.get_sprite_set({ tint = tint })
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

local icons = IconCatalog:create({ folder = "__reskins-assets-angels__/graphics/icons" })

---Gets the icon for Angel's blast furnace, in the tints given by `params`.
M.get_icon = icons:tinted("blast-furnace"):build("get_icon")

return M
