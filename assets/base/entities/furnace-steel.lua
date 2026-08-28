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
-- Working lights are split between base assets (plain/unoriented) and the
-- bobs fluid-furnace lights folder (left/right oriented variants).

---@param orientation? "left" | "right"
---@return Animation
local function get_steel_furnace_fire_animation(orientation)
	local filename
	if orientation then
		filename = _defines.assets_source.bobs_assets
			.. "/graphics/entity/furnace-steel-fluid/lights/furnace-steel-fluid-fire-"
			.. orientation
			.. ".png"
	else
		filename = _defines.assets_source.base_assets .. "/graphics/entity/furnace-steel/lights/furnace-steel-fire.png"
	end

	return {
		filename = filename,
		priority = "high",
		line_length = 8,
		width = 57,
		height = 81,
		frame_count = 48,
		shift = util.by_pixel(-0.75, 5.75),
		draw_as_glow = true,
		scale = 0.5,
	}
end

---@return Animation
local function get_steel_furnace_glow()
	return {
		filename = "__base__/graphics/entity/steel-furnace/steel-furnace-glow.png",
		priority = "high",
		width = 60,
		height = 43,
		shift = { 0.03125, 0.640625 },
		blend_mode = "additive",
		draw_as_glow = true,
	}
end

---@param orientation? "left" | "right"
---@return Animation
local function get_steel_furnace_working_light(orientation)
	local filename
	if orientation then
		filename = _defines.assets_source.bobs_assets
			.. "/graphics/entity/furnace-steel-fluid/lights/furnace-steel-fluid-working-"
			.. orientation
			.. ".png"
	else
		filename = _defines.assets_source.base_assets .. "/graphics/entity/furnace-steel/lights/furnace-steel-working.png"
	end

	return {
		filename = filename,
		priority = "high",
		width = 172,
		height = 174,
		shift = util.by_pixel(-1, 2),
		blend_mode = "additive",
		draw_as_glow = true,
		scale = 0.5,
	}
end

---@param orientation? "left" | "right"
---@return Animation
local function get_steel_furnace_ground_light(orientation)
	local filename
	if orientation then
		filename = _defines.assets_source.bobs_assets
			.. "/graphics/entity/furnace-steel-fluid/lights/furnace-steel-fluid-ground-light-"
			.. orientation
			.. ".png"
	else
		filename = _defines.assets_source.base_assets
			.. "/graphics/entity/furnace-steel/lights/furnace-steel-ground-light.png"
	end

	return {
		filename = filename,
		priority = "high",
		width = 152,
		height = 126,
		shift = util.by_pixel(1, 48),
		blend_mode = "additive",
		draw_as_light = true,
		scale = 0.5,
	}
end

---Gets the water reflection of a generic steel furnace.
---@return WaterReflectionDefinition
local function get_steel_furnace_water_reflection()
	---@type WaterReflectionDefinition
	local water_reflection = {
		pictures = {
			filename = "__base__/graphics/entity/steel-furnace/steel-furnace-reflection.png",
			priority = "extra-high",
			width = 20,
			height = 24,
			shift = util.by_pixel(0, 45),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}

	return water_reflection
end

-- Working visualisation builders

---@return WorkingVisualisation[]
local function get_standard_working_visualisations()
	return {
		{
			fadeout = true,
			effect = "flicker",
			animation = {
				filename = "__base__/graphics/entity/steel-furnace/steel-furnace-fire.png",
				priority = "high",
				line_length = 8,
				width = 57,
				height = 81,
				frame_count = 48,
				draw_as_glow = true,
				shift = util.by_pixel(-0.75, 5.75),
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			effect = "flicker",
			animation = {
				filename = "__base__/graphics/entity/steel-furnace/steel-furnace-glow.png",
				priority = "high",
				width = 60,
				height = 43,
				draw_as_glow = true,
				shift = { 0.03125, 0.640625 },
				blend_mode = "additive",
			},
		},
		{
			fadeout = true,
			effect = "flicker",
			animation = {
				filename = "__base__/graphics/entity/steel-furnace/steel-furnace-working.png",
				priority = "high",
				line_length = 1,
				width = 128,
				height = 150,
				draw_as_glow = true,
				shift = util.by_pixel(0, -5),
				blend_mode = "additive",
				scale = 0.5,
			},
		},
		{
			fadeout = true,
			effect = "flicker",
			animation = {
				filename = "__base__/graphics/entity/steel-furnace/steel-furnace-ground-light.png",
				priority = "high",
				line_length = 1,
				width = 152,
				height = 126,
				draw_as_light = true,
				shift = util.by_pixel(1, 48),
				blend_mode = "additive",
				scale = 0.5,
			},
		},
	}
end
---@return WorkingVisualisation[]
local function get_fluid_working_visualisations()
	return {
		-- Fire effect
		{
			fadeout = true,
			effect = "flicker",
			east_animation = get_steel_furnace_fire_animation("right"),
			south_animation = get_steel_furnace_fire_animation(),
			west_animation = get_steel_furnace_fire_animation("left"),
		},
		-- Glow
		{
			fadeout = true,
			effect = "flicker",
			east_animation = get_steel_furnace_glow(),
			south_animation = get_steel_furnace_glow(),
			west_animation = get_steel_furnace_glow(),
		},
		-- Furnace flicker
		{
			fadeout = true,
			effect = "flicker",
			east_animation = get_steel_furnace_working_light("right"),
			south_animation = get_steel_furnace_working_light(),
			west_animation = get_steel_furnace_working_light("left"),
		},
		-- Ground light
		{
			fadeout = true,
			effect = "flicker",
			east_animation = get_steel_furnace_ground_light("right"),
			south_animation = get_steel_furnace_ground_light(),
			west_animation = get_steel_furnace_ground_light("left"),
		},
	}
end

---@return WorkingVisualisation[]
local function get_chemical_working_visualisations_main()
	return {
		-- Fire effect
		{
			fadeout = true,
			effect = "flicker",
			north_animation = get_steel_furnace_fire_animation(),
			south_animation = get_steel_furnace_fire_animation("right"),
			west_animation = get_steel_furnace_fire_animation(),
		},
		-- Glow
		{
			fadeout = true,
			effect = "flicker",
			north_animation = get_steel_furnace_glow(),
			south_animation = get_steel_furnace_glow(),
			west_animation = get_steel_furnace_glow(),
		},
		-- Furnace flicker
		{
			fadeout = true,
			effect = "flicker",
			north_animation = get_steel_furnace_working_light(),
			south_animation = get_steel_furnace_working_light("right"),
			west_animation = get_steel_furnace_working_light(),
		},
		-- Ground light
		{
			fadeout = true,
			effect = "flicker",
			north_animation = get_steel_furnace_ground_light(),
			south_animation = get_steel_furnace_ground_light("right"),
			west_animation = get_steel_furnace_ground_light(),
		},
	}
end

---@return WorkingVisualisation[]
local function get_chemical_working_visualisations_flipped()
	return {
		-- Fire effect
		{
			fadeout = true,
			effect = "flicker",
			north_animation = get_steel_furnace_fire_animation(),
			east_animation = get_steel_furnace_fire_animation(),
			south_animation = get_steel_furnace_fire_animation("left"),
		},
		-- Glow
		{
			fadeout = true,
			effect = "flicker",
			north_animation = get_steel_furnace_glow(),
			east_animation = get_steel_furnace_glow(),
			south_animation = get_steel_furnace_glow(),
		},
		-- Furnace flicker
		{
			fadeout = true,
			effect = "flicker",
			north_animation = get_steel_furnace_working_light(),
			east_animation = get_steel_furnace_working_light(),
			south_animation = get_steel_furnace_working_light("left"),
		},
		-- Ground light
		{
			fadeout = true,
			effect = "flicker",
			north_animation = get_steel_furnace_ground_light(),
			east_animation = get_steel_furnace_ground_light(),
			south_animation = get_steel_furnace_ground_light("left"),
		},
	}
end

---@return WorkingVisualisation[]
local function get_chemical_fluid_working_visualisations_main()
	return {
		-- Fire effect
		{
			fadeout = true,
			effect = "flicker",
			south_animation = get_steel_furnace_fire_animation("right"),
			west_animation = get_steel_furnace_fire_animation("left"),
		},
		-- Glow
		{
			fadeout = true,
			effect = "flicker",
			south_animation = get_steel_furnace_glow(),
			west_animation = get_steel_furnace_glow(),
		},
		-- Furnace flicker
		{
			fadeout = true,
			effect = "flicker",
			south_animation = get_steel_furnace_working_light("right"),
			west_animation = get_steel_furnace_working_light("left"),
		},
		-- Ground light
		{
			fadeout = true,
			effect = "flicker",
			south_animation = get_steel_furnace_ground_light("right"),
			west_animation = get_steel_furnace_ground_light("left"),
		},
	}
end

---@return WorkingVisualisation[]
local function get_chemical_fluid_working_visualisations_flipped()
	return {
		-- Fire effect
		{
			fadeout = true,
			effect = "flicker",
			east_animation = get_steel_furnace_fire_animation("right"),
			south_animation = get_steel_furnace_fire_animation("left"),
		},
		-- Glow
		{
			fadeout = true,
			effect = "flicker",
			east_animation = get_steel_furnace_glow(),
			south_animation = get_steel_furnace_glow(),
		},
		-- Furnace flicker
		{
			fadeout = true,
			effect = "flicker",
			east_animation = get_steel_furnace_working_light("right"),
			south_animation = get_steel_furnace_working_light("left"),
		},
		-- Ground light
		{
			fadeout = true,
			effect = "flicker",
			east_animation = get_steel_furnace_ground_light("right"),
			south_animation = get_steel_furnace_ground_light("left"),
		},
	}
end

-- Animation layer builder
-- Constructs the base+mask+highlights+shadow layer stack for a given variant.

---@param variant "standard" | "fluid" | "chemical" | "chemical-fluid"
---@param tint Color?
---@param is_mirror boolean?
---@return Animation
local function build_steel_furnace_animation(variant, tint, is_mirror)
	local base_path = _defines.assets_source.base_assets .. "/graphics/entity/furnace-steel/"
	local bobs_folder = ({
		standard = nil, -- uses base_path
		fluid = _defines.assets_source.bobs_assets .. "/graphics/entity/furnace-steel-fluid/",
		chemical = _defines.assets_source.bobs_assets .. "/graphics/entity/furnace-steel-chemical/",
		["chemical-fluid"] = _defines.assets_source.bobs_assets .. "/graphics/entity/furnace-steel-chemical-fluid/",
	})[variant]

	local assets_path = bobs_folder or base_path
	local image_name = ({
		standard = "furnace-steel",
		fluid = "furnace-steel-fluid",
		chemical = "furnace-steel-chemical",
		["chemical-fluid"] = "furnace-steel-chemical-fluid",
	})[variant]

	if is_mirror then
		image_name = image_name .. "-mirror"
	end

	local shadow_filename
	if bobs_folder then
		shadow_filename = bobs_folder .. image_name .. "-shadow.png"
	else
		shadow_filename = base_path .. "shadows/furnace-steel-shadow.png"
	end

	---@type Animation[]
	local layers = {
		{
			filename = assets_path .. image_name .. "-base.png",
			priority = "high",
			width = 172,
			height = 174,
			shift = util.by_pixel(-1, 2),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = assets_path .. image_name .. "-mask.png",
			priority = "high",
			width = 172,
			height = 174,
			tint = tint,
			shift = util.by_pixel(-1, 2),
			scale = 0.5,
		})
		table.insert(layers, {
			filename = assets_path .. image_name .. "-highlights.png",
			priority = "high",
			width = 172,
			height = 174,
			blend_mode = "additive-soft",
			shift = util.by_pixel(-1, 2),
			scale = 0.5,
		})
	end

	table.insert(layers, {
		filename = shadow_filename,
		priority = "high",
		width = 282,
		height = 142,
		draw_as_shadow = true,
		shift = util.by_pixel(38.5, 3.5),
		scale = 0.5,
	})

	return { layers = layers }
end

-- Graphics set builders

---@param tint Color?
---@param variant "standard" | "fluid" | "chemical" | "chemical-fluid"
---@return CraftingMachineGraphicsSet
local function get_graphics_set(tint, variant)
	local raw_animation = build_steel_furnace_animation(variant, tint)

	local animation
	local working_visualisations

	if variant == "standard" then
		animation = raw_animation
		working_visualisations = get_standard_working_visualisations()
	elseif variant == "fluid" then
		animation = _sprites.make_4way_animation_from_spritesheet(raw_animation)
		working_visualisations = get_fluid_working_visualisations()
	elseif variant == "chemical" then
		animation = _sprites.make_4way_animation_from_spritesheet(raw_animation)
		working_visualisations = get_chemical_working_visualisations_main()
	elseif variant == "chemical-fluid" then
		animation = _sprites.make_4way_animation_from_spritesheet(raw_animation)
		working_visualisations = get_chemical_fluid_working_visualisations_main()
	end

	---@type CraftingMachineGraphicsSet
	return {
		animation = animation --[[@as Animation4Way]],
		working_visualisations = working_visualisations,
		water_reflection = get_steel_furnace_water_reflection(),
	}
end

---@param tint Color?
---@param variant "chemical" | "chemical-fluid"
---@return CraftingMachineGraphicsSet
local function get_graphics_set_flipped(tint, variant)
	local raw_animation = build_steel_furnace_animation(variant, tint, true)

	local working_visualisations
	if variant == "chemical" then
		working_visualisations = get_chemical_working_visualisations_flipped()
	elseif variant == "chemical-fluid" then
		working_visualisations = get_chemical_fluid_working_visualisations_flipped()
	end

	---@type CraftingMachineGraphicsSet
	return {
		animation = _sprites.make_4way_animation_from_spritesheet(raw_animation) --[[@as Animation4Way]],
		working_visualisations = working_visualisations,
	}
end

---@param tint Color?
---@param variant "standard" | "fluid" | "chemical" | "chemical-fluid"
---@return RotatedAnimationVariations
local function get_corpse_animation(tint, variant)
	local direction_count = variant == "standard" and 1 or 4

	local image_name = ({
		standard = "furnace-steel-remnants",
		fluid = "furnace-steel-fluid-remnants",
		chemical = "furnace-steel-chemical-remnants",
		["chemical-fluid"] = "furnace-steel-chemical-fluid-remnants",
	})[variant]

	local assets_path = ({
		standard = _defines.assets_source.base_assets .. "/graphics/entity/furnace-steel/remnants/",
		fluid = _defines.assets_source.bobs_assets .. "/graphics/entity/furnace-steel-fluid/remnants/",
		chemical = _defines.assets_source.bobs_assets .. "/graphics/entity/furnace-steel-chemical/remnants/",
		["chemical-fluid"] = _defines.assets_source.bobs_assets
			.. "/graphics/entity/furnace-steel-chemical-fluid/remnants/",
	})[variant]

	---@type RotatedAnimationVariations
	local animation = {
		layers = {
			{
				filename = assets_path .. image_name .. "-base.png",
				width = 268,
				height = 238,
				line_length = direction_count,
				direction_count = direction_count,
				shift = util.by_pixel(4, 0.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. image_name .. "-mask.png",
			width = 268,
			height = 238,
			line_length = direction_count,
			direction_count = direction_count,
			tint = tint,
			shift = util.by_pixel(4, 0.5),
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = assets_path .. image_name .. "-highlights.png",
			width = 268,
			height = 238,
			line_length = direction_count,
			direction_count = direction_count,
			blend_mode = "additive-soft",
			shift = util.by_pixel(4, 0.5),
			scale = 0.5,
		})
	end

	return animation
end

-- Public API

---@class FurnaceSteelSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set rather than drawn
---untinted.
---@field tint Color?
---The variant to draw.
---@field variant "standard"

---Gets the sprite set for the vanilla steel furnace.
---@param params FurnaceSteelSpriteSetParams # The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---### Examples
---```lua
---local furnace_steel = require("__reskins-assets-api__.assets.base.entities.furnace-steel")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = furnace_steel.get_sprite_set({ tint = tint, variant = variant })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	-- FIXME: `energy_source.light_flicker` belongs on the prototype rather than in sprite data,
	-- so it has no home on `CraftingMachineSpriteSet`. Until it does, this furnace's fire
	-- flickers at full brightness.
	local graphics_set = get_graphics_set(params.tint, params.variant)
	local graphics_set_flipped = nil
	if params.variant == "chemical" or params.variant == "chemical-fluid" then
		graphics_set_flipped = get_graphics_set_flipped(params.tint, params.variant)
	end

	local has_fluid_boxes = params.variant ~= "standard"

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
			-- Chemical variants have fluid boxes but must show them regardless of active recipe.
			fluid_boxes_off_when_no_fluid_recipe = not has_fluid_boxes,
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
	{ "variant", V.one_of({ "standard", "fluid", "chemical", "chemical-fluid" }) },
	{ "tint", Common.color:optional() },
})

---Gets the icon for a steel furnace of the given `variant`, in the given `tint`.
---@param variant "standard"|"fluid"|"chemical"|"chemical-fluid" # The furnace the icon is drawn for.
---@param tint Color? # The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(variant, tint)
	check_get_icon(variant, tint)

	-- The standard furnace wears vanilla artwork; the rest are Bob's.
	local name = variant == "standard" and "furnace-steel" or "furnace-steel-" .. variant
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
