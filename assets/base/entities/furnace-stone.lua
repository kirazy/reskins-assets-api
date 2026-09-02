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

-- Private sprite helpers

---@return Animation
---@private
local function get_stone_furnace_fire_animation()
	return {
		filename = "__base__/graphics/entity/stone-furnace/stone-furnace-fire.png",
		priority = "extra-high",
		width = 41,
		height = 100,
		line_length = 8,
		frame_count = 48,
		draw_as_glow = true,
		shift = util.by_pixel(-0.75, 5.5),
		scale = 0.5,
	}
end

---@return Animation
---@private
local function get_stone_furnace_ground_light()
	return {
		filename = "__base__/graphics/entity/stone-furnace/stone-furnace-ground-light.png",
		blend_mode = "additive",
		draw_as_light = true,
		width = 116,
		height = 110,
		repeat_count = 48,
		shift = util.by_pixel(-1, 44),
		scale = 0.5,
	}
end

---@param orientation? "bottom" | "left-front" | "left-rear" | "right-front" | "right-rear"
---@return Animation
---@private
local function get_stone_furnace_working_light(orientation)
	local filename
	if orientation then
		local bobs_lights = _defines.assets_source.bobs_assets .. "/graphics/entity/furnace-stone-chemical/lights/"
		filename = bobs_lights .. "furnace-stone-chemical-light-" .. orientation .. "-obscure.png"
	else
		filename = _defines.assets_source.base_assets .. "/graphics/entity/furnace-stone/lights/furnace-stone-light.png"
	end

	return {
		filename = filename,
		blend_mode = "additive",
		draw_as_glow = true,
		width = 152,
		height = 172,
		repeat_count = 48,
		shift = util.by_pixel(0, 1),
		scale = 0.5,
	}
end

-- Graphics set builders

---Gets the water reflection of a generic stone furnace.
---@return WaterReflectionDefinition
local function get_stone_furnace_water_reflection()
	---@type WaterReflectionDefinition
	local water_reflection = {
		pictures = {
			filename = "__base__/graphics/entity/stone-furnace/stone-furnace-reflection.png",
			priority = "extra-high",
			width = 16,
			height = 16,
			shift = util.by_pixel(0, 35),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}

	return water_reflection
end

---@param tint Color?
---@param variant "standard" | "chemical"
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint, variant)
	local base_path = _defines.assets_source.base_assets .. "/graphics/entity/furnace-stone/"
	local bobs_path = _defines.assets_source.bobs_assets .. "/graphics/entity/furnace-stone-chemical/"

	local is_chemical = variant == "chemical"
	local assets_path = is_chemical and bobs_path or base_path
	local image_name = is_chemical and "furnace-stone-chemical" or "furnace-stone"
	local shadow_filename = is_chemical and (bobs_path .. "furnace-stone-chemical-shadow.png")
		or (base_path .. "shadows/furnace-stone-shadow.png")

	---@type Animation[]
	local layers = {
		{
			filename = assets_path .. image_name .. "-base.png",
			priority = "high",
			width = 152,
			height = 152,
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. image_name .. "-mask.png",
			priority = "high",
			width = 152,
			height = 152,
			tint = tint,
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. image_name .. "-highlights.png",
			priority = "high",
			width = 152,
			height = 152,
			blend_mode = "additive-soft",
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		})
	end

	table.insert(layers, {
		filename = shadow_filename,
		priority = "high",
		width = 176,
		height = 140,
		draw_as_shadow = true,
		shift = util.by_pixel(12, 3),
		scale = 0.5,
	})

	local animation = { layers = layers }

	---@type WorkingVisualisation[]
	local working_visualisations
	if is_chemical then
		working_visualisations = {
			-- Fire effect
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_fire_animation(),
				south_animation = get_stone_furnace_fire_animation(),
				west_animation = get_stone_furnace_fire_animation(),
			},
			-- Furnace light
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_working_light("right-rear"),
				east_animation = get_stone_furnace_working_light("bottom"),
				south_animation = get_stone_furnace_working_light("left-front"),
				west_animation = get_stone_furnace_working_light(),
			},
			-- Ground light
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_ground_light(),
				south_animation = get_stone_furnace_ground_light(),
				west_animation = get_stone_furnace_ground_light(),
			},
		}
		animation = _sprites.make_4way_animation_from_spritesheet(animation)
	else
		working_visualisations = {
			-- Fire effect
			{
				fadeout = true,
				effect = "flicker",
				animation = get_stone_furnace_fire_animation(),
			},
			-- Furnace light
			{
				fadeout = true,
				effect = "flicker",
				animation = get_stone_furnace_working_light(),
			},
			-- Ground light
			{
				fadeout = true,
				effect = "flicker",
				animation = get_stone_furnace_ground_light(),
			},
		}
	end

	---@type CraftingMachineGraphicsSet
	return {
		animation = animation,
		working_visualisations = working_visualisations,
		water_reflection = get_stone_furnace_water_reflection(),
	}
end

---@param tint Color?
---@return CraftingMachineGraphicsSet
---@private
local function get_graphics_set_flipped(tint)
	local bobs_path = _defines.assets_source.bobs_assets .. "/graphics/entity/furnace-stone-chemical/"

	---@type Animation[]
	local layers = {
		{
			filename = bobs_path .. "furnace-stone-chemical-mirror-base.png",
			priority = "high",
			width = 152,
			height = 152,
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = bobs_path .. "furnace-stone-chemical-mirror-mask.png",
			priority = "high",
			width = 152,
			height = 152,
			tint = tint,
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		})
		table.insert(layers, {
			filename = bobs_path .. "furnace-stone-chemical-mirror-highlights.png",
			priority = "high",
			width = 152,
			height = 152,
			blend_mode = "additive-soft",
			shift = util.by_pixel(0, 1),
			scale = 0.5,
		})
	end

	table.insert(layers, {
		filename = bobs_path .. "furnace-stone-chemical-mirror-shadow.png",
		priority = "high",
		width = 176,
		height = 140,
		draw_as_shadow = true,
		shift = util.by_pixel(12, 3),
		scale = 0.5,
	})

	---@type CraftingMachineGraphicsSet
	return {
		animation = _sprites.make_4way_animation_from_spritesheet({ layers = layers }),
		working_visualisations = {
			-- Fire effect
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_fire_animation(),
				east_animation = get_stone_furnace_fire_animation(),
				south_animation = get_stone_furnace_fire_animation(),
			},
			-- Furnace light
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_working_light("left-rear"),
				east_animation = get_stone_furnace_working_light(),
				south_animation = get_stone_furnace_working_light("right-front"),
				west_animation = get_stone_furnace_working_light("bottom"),
			},
			-- Ground light
			{
				fadeout = true,
				effect = "flicker",
				north_animation = get_stone_furnace_ground_light(),
				east_animation = get_stone_furnace_ground_light(),
				south_animation = get_stone_furnace_ground_light(),
			},
		},
	}
end

---@param tint Color?
---@param variant "standard" | "chemical"
---@return RotatedAnimationVariations
local function get_corpse_animation(tint, variant)
	local is_chemical = variant == "chemical"
	local direction_count = is_chemical and 4 or 1
	local image_name = is_chemical and "furnace-stone-chemical-remnants" or "furnace-stone-remnants"
	local assets_path = is_chemical
			and (_defines.assets_source.bobs_assets .. "/graphics/entity/furnace-stone-chemical/remnants/")
		or (_defines.assets_source.base_assets .. "/graphics/entity/furnace-stone/remnants/")

	---@type RotatedAnimationVariations
	local animation = {
		layers = {
			{
				filename = assets_path .. image_name .. "-base.png",
				width = 202,
				height = 180,
				line_length = direction_count,
				direction_count = direction_count,
				shift = util.by_pixel(2, 17),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. image_name .. "-mask.png",
			width = 202,
			height = 180,
			line_length = direction_count,
			direction_count = direction_count,
			tint = tint,
			shift = util.by_pixel(2, 17),
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. image_name .. "-highlights.png",
			width = 202,
			height = 180,
			line_length = direction_count,
			direction_count = direction_count,
			blend_mode = "additive-soft",
			shift = util.by_pixel(2, 17),
			scale = 0.5,
		})
	end

	return animation
end

-- Public API

---@class FurnaceStoneSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The variant to draw.
---@field variant "standard"

---Gets the sprite set for the vanilla stone furnace.
---@param params FurnaceStoneSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local furnace_stone = require("__reskins-assets-api__.assets.base.entities.furnace-stone")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = furnace_stone.get_sprite_set({ tint = tint, variant = variant })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	-- FIXME: `energy_source.light_flicker` belongs on the prototype rather than in sprite data,
	-- so it has no home on `CraftingMachineSpriteSet`. Until it does, this furnace's fire
	-- flickers at full brightness.
	local graphics_set = get_graphics_set(params.tint, params.variant)
	local graphics_set_flipped = nil
	if params.variant == "chemical" then
		graphics_set_flipped = get_graphics_set_flipped(params.tint)
	end

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			graphics_set = graphics_set,
			graphics_set_flipped = graphics_set_flipped,
			fluid_boxes = {
				{
					pipe_picture = nil,
				},
			},
			fluid_boxes_off_when_no_fluid_recipe = params.variant ~= "chemical" and nil or false,
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint, params.variant) },
			water_reflection = nil,
			nominal_width = 2,
			nominal_height = 2,
		},
	}

	return definition
end

local check_get_icon = V.signature("get_icon", {
	{ "variant", V.one_of({ "standard", "chemical" }) },
	{ "tint", Common.color:optional() },
})

---Gets the icon for a stone furnace of the given `variant`, in the given `tint`.
---@param variant "standard"|"chemical" # The furnace the icon is drawn for.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(variant, tint)
	check_get_icon(variant, tint)

	-- The standard furnace uses vanilla artwork; the rest are Bob's.
	local name = variant == "standard" and "furnace-stone" or "furnace-stone-" .. variant
	local mod = variant == "standard" and "__reskins-assets-base__" or "__reskins-assets-bobs__"
	local folder = mod .. "/graphics/icons/" .. name .. "/" .. name .. "-icon-"

	---@type SafeIconData[]
	local icon = { { icon = folder .. "base.png", icon_size = 64, scale = 0.5 } }

	if tint then
		table.insert(icon, { icon = folder .. "mask.png", icon_size = 64, scale = 0.5, tint = tint })
		table.insert(icon, { icon = folder .. "highlights.png", icon_size = 64, scale = 0.5, tint = { 1, 1, 1, 0 } })
	end

	return icon
end

return M
