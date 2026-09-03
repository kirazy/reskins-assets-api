---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local IconCatalog = require("api.icon-catalog")

local M = {}

local BASE_FOLDER = "__base__/graphics/entity/beacon/"
local ASSETS_FOLDER = "__reskins-assets-base__/graphics/entity/beacon/"
local GOD_MODULE_FOLDER = "__reskins-assets-bobs__/graphics/entity/beacon/module-slots/5-lights/"

---The number of module slots the beacon's artwork is drawn for.
---@alias BeaconSlotCount
---| 2
---| 4
---| 6

---@param slot_count integer?
---@return BeaconSlotCount
local function resolve_slot_count(slot_count)
	if not slot_count or slot_count <= 2 then
		return 2
	elseif slot_count <= 4 then
		return 4
	else
		return 6
	end
end

---@param slot_count BeaconSlotCount
---@param tint Color?
---@return AnimationElement
---@nodiscard
local function get_base_animation_element(slot_count, tint)
	local folder = ASSETS_FOLDER .. slot_count .. "-slots/beacon-" .. slot_count .. "-slots-bottom-"

	local layers = {
		{
			filename = folder .. "base.png",
			width = 212,
			height = 192,
			shift = util.by_pixel(0.5, 1),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = folder .. "mask.png",
			width = 212,
			height = 192,
			tint = tint,
			shift = util.by_pixel(0.5, 1),
			scale = 0.5,
		})
		table.insert(layers, {
			filename = folder .. "highlights.png",
			width = 212,
			height = 192,
			blend_mode = "additive-soft",
			shift = util.by_pixel(0.5, 1),
			scale = 0.5,
		})
	end

	-- Shadows are always appended last.
	table.insert(layers, {
		filename = BASE_FOLDER .. "beacon-shadow.png",
		width = 244,
		height = 176,
		draw_as_shadow = true,
		shift = util.by_pixel(12.5, 0.5),
		scale = 0.5,
	})

	---@type AnimationElement
	return {
		render_layer = "floor-mechanics",
		always_draw = true,
		animation = { layers = layers },
	}
end

---@param slot_count BeaconSlotCount
---@return AnimationElement
---@nodiscard
local function get_antenna_top_animation_element(slot_count)
	---@type AnimationElement
	return {
		render_layer = "object",
		always_draw = true,
		animation = {
			filename = ASSETS_FOLDER .. slot_count .. "-slots/beacon-" .. slot_count .. "-slots-top.png",
			width = 96,
			height = 140,
			scale = 0.5,
			repeat_count = 45,
			animation_speed = 0.5,
			shift = util.by_pixel(3, -19),
		},
	}
end

---@param apply_tint boolean
---@return AnimationElement
---@nodiscard
local function get_light_animation_element(apply_tint)
	---@type AnimationElement
	return {
		render_layer = "object",
		apply_tint = apply_tint,
		always_draw = false,
		animation = {
			filename = BASE_FOLDER .. "beacon-light.png",
			line_length = 9,
			width = 110,
			height = 186,
			frame_count = 45,
			animation_speed = 0.5,
			blend_mode = "additive",
			shift = util.by_pixel(0.5, -18),
			scale = 0.5,
		},
	}
end

---@return AnimationElement
---@nodiscard
local function get_4_slot_module_overlay()
	---@type AnimationElement
	return {
		-- Above modules, below lights.
		render_layer = "transport-belt-circuit-connector",
		animation = {
			layers = {
				{
					filename = ASSETS_FOLDER .. "4-slots/beacon-4-slots-bottom-slot-overlay.png",
					width = 212,
					height = 192,
					shift = util.by_pixel(0.5, 1),
					scale = 0.5,
				},
			},
		},
	}
end

---@param tint Color?
---@return AnimationElement
---@nodiscard
local function get_6_slot_module_overlay(tint)
	local folder = ASSETS_FOLDER .. "6-slots/beacon-6-slots-bottom-slot-overlay-"

	local layers = {
		{
			filename = folder .. "base.png",
			width = 212,
			height = 192,
			shift = util.by_pixel(0.5, 1),
			scale = 0.5,
		},
	}

	if tint then
		table.insert(layers, {
			filename = folder .. "mask.png",
			width = 212,
			height = 192,
			tint = tint,
			shift = util.by_pixel(0.5, 1),
			scale = 0.5,
		})
		table.insert(layers, {
			filename = folder .. "highlights.png",
			width = 212,
			height = 192,
			blend_mode = "additive-soft",
			shift = util.by_pixel(0.5, 1),
			scale = 0.5,
		})
	end

	---@type AnimationElement
	return {
		-- Above modules, below lights.
		render_layer = "transport-belt-circuit-connector",
		animation = { layers = layers },
	}
end

---Draws the visualizations for one of the beacon's two module slots, offset by `shift`.
---@alias BeaconModuleSlotCreator fun(shift: Vector, secondary_draw_order: int8): BeaconModuleVisualization[]

---The creators drawing an art style's two module slots.
---@class (exact) BeaconModuleSlotCreators
---Draws the slot to the lower left.
---@field slot_1 BeaconModuleSlotCreator
---Draws the slot to the upper right.
---@field slot_2 BeaconModuleSlotCreator

---The creators for each art style a beacon's module slots can be drawn in. An art style is named by
---the caller, so a beacon can carry as many as it has artwork for.
M.module_slots = {}

---Gets the creators drawing the base game's own module slots.
---@return BeaconModuleSlotCreators
---@nodiscard
function M.module_slots.get_vanilla_creators()
	---@type BeaconModuleSlotCreators
	return {
		slot_1 = function(shift, secondary_draw_order)
			---@type BeaconModuleVisualization[]
			return {
				{
					has_empty_slot = true,
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = BASE_FOLDER .. "beacon-module-slot-1.png",
						width = 50,
						height = 66,
						line_length = 4,
						variation_count = 4,
						shift = util.add_shift(util.by_pixel(-16, 14.5), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "primary",
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = BASE_FOLDER .. "beacon-module-mask-box-1.png",
						width = 36,
						height = 32,
						line_length = 3,
						variation_count = 3,
						shift = util.add_shift(util.by_pixel(-17, 15), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "secondary",
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = BASE_FOLDER .. "beacon-module-mask-lights-1.png",
						width = 26,
						height = 12,
						line_length = 3,
						variation_count = 3,
						shift = util.add_shift(util.by_pixel(-18.5, 13), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "secondary",
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = BASE_FOLDER .. "beacon-module-lights-1.png",
						width = 56,
						height = 42,
						line_length = 3,
						variation_count = 3,
						draw_as_light = true,
						shift = util.add_shift(util.by_pixel(-18, 13), shift),
						scale = 0.5,
					},
				},
			}
		end,
		slot_2 = function(shift, secondary_draw_order)
			---@type BeaconModuleVisualization[]
			return {
				{
					has_empty_slot = true,
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = BASE_FOLDER .. "beacon-module-slot-2.png",
						width = 46,
						height = 44,
						line_length = 4,
						variation_count = 4,
						shift = util.add_shift(util.by_pixel(19, -12), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "primary",
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = BASE_FOLDER .. "beacon-module-mask-box-2.png",
						width = 36,
						height = 26,
						line_length = 3,
						variation_count = 3,
						shift = util.add_shift(util.by_pixel(20.5, -12), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "secondary",
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = BASE_FOLDER .. "beacon-module-mask-lights-2.png",
						width = 24,
						height = 14,
						line_length = 3,
						variation_count = 3,
						shift = util.add_shift(util.by_pixel(22, -15.5), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "secondary",
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = BASE_FOLDER .. "beacon-module-lights-2.png",
						width = 66,
						height = 46,
						line_length = 3,
						variation_count = 3,
						draw_as_light = true,
						shift = util.add_shift(util.by_pixel(22, -16), shift),
						scale = 0.5,
					},
				},
			}
		end,
	}
end

local module_slot_creators = V.shape({
	slot_1 = V.func():describe_as("a function drawing a module slot"),
	slot_2 = V.func():describe_as("a function drawing a module slot"),
}):describe_as("a pair of module slot creators")

local check_get_tiered_creators = V.signature("get_tiered_creators", {
	{ "light_count", V.one_of({ 5, 8 }) },
})

---Gets the creators drawing module slots lit by `light_count` lights.
---@param light_count 5|8 The number of lights the slot is drawn with.
---@return BeaconModuleSlotCreators
---@nodiscard
function M.module_slots.get_tiered_creators(light_count)
	check_get_tiered_creators(light_count)

	local folder = ASSETS_FOLDER .. "module-slots/" .. light_count .. "-lights/"

	---@type BeaconModuleSlotCreators
	return {
		slot_1 = function(shift, secondary_draw_order)
			---@type BeaconModuleVisualization[]
			return {
				{
					has_empty_slot = true,
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "beacon-module-slot-1.png",
						width = 50,
						height = 66,
						line_length = light_count + 1,
						variation_count = light_count + 1,
						shift = util.add_shift(util.by_pixel(-16, 14.5), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "primary",
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "beacon-module-mask-box-1.png",
						width = 36,
						height = 32,
						line_length = light_count,
						variation_count = light_count,
						shift = util.add_shift(util.by_pixel(-17, 15), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "secondary",
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "beacon-module-mask-lights-1.png",
						width = 26,
						height = 22,
						line_length = light_count,
						variation_count = light_count,
						shift = util.add_shift(util.by_pixel(-18.5, 13), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "secondary",
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "beacon-module-lights-1.png",
						width = 56,
						height = 42,
						line_length = light_count,
						variation_count = light_count,
						draw_as_light = true,
						shift = util.add_shift(util.by_pixel(-18, 13), shift),
						scale = 0.5,
					},
				},
			}
		end,
		slot_2 = function(shift, secondary_draw_order)
			---@type BeaconModuleVisualization[]
			return {
				{
					has_empty_slot = true,
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "beacon-module-slot-2.png",
						width = 46,
						height = 44,
						line_length = light_count + 1,
						variation_count = light_count + 1,
						shift = util.add_shift(util.by_pixel(19, -12), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "primary",
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "beacon-module-mask-box-2.png",
						width = 36,
						height = 28,
						line_length = light_count,
						variation_count = light_count,
						shift = util.add_shift(util.by_pixel(20.5, -12), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "secondary",
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "beacon-module-mask-lights-2.png",
						width = 24,
						height = 16,
						line_length = light_count,
						variation_count = light_count,
						shift = util.add_shift(util.by_pixel(21.5, -15.5), shift),
						scale = 0.5,
					},
				},
				{
					apply_module_tint = "secondary",
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "beacon-module-lights-2.png",
						width = 66,
						height = 46,
						line_length = light_count,
						variation_count = light_count,
						draw_as_light = true,
						shift = util.add_shift(util.by_pixel(22, -16), shift),
						scale = 0.5,
					},
				},
			}
		end,
	}
end

local check_get_god_module_creators = V.signature("get_god_module_creators", {
	{ "variant", V.one_of({ "base", "productivity", "quality" }) },
})

---Gets the creators drawing module slots holding one of Bob's god modules.
---@param variant "base"|"productivity"|"quality" The god module the slot holds.
---@return BeaconModuleSlotCreators
---@nodiscard
function M.module_slots.get_god_module_creators(variant)
	check_get_god_module_creators(variant)

	local folder = GOD_MODULE_FOLDER .. "god-module-" .. variant .. "-module-"

	-- Every god module shares the one box, drawn for the base variant.
	local box_folder = GOD_MODULE_FOLDER .. "god-module-base-module-"

	---@type BeaconModuleSlotCreators
	return {
		slot_1 = function(shift, secondary_draw_order)
			---@type BeaconModuleVisualization[]
			return {
				{
					has_empty_slot = true,
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "slot-1.png",
						width = 50,
						height = 66,
						line_length = 2,
						variation_count = 2,
						shift = util.add_shift(util.by_pixel(-16, 14.5), shift),
						scale = 0.5,
					},
				},
				{
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = box_folder .. "mask-box-1.png",
						width = 36,
						height = 32,
						line_length = 1,
						variation_count = 1,
						shift = util.add_shift(util.by_pixel(-17, 15), shift),
						scale = 0.5,
					},
				},
				{
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "mask-lights-1.png",
						width = 26,
						height = 22,
						line_length = 1,
						variation_count = 1,
						shift = util.add_shift(util.by_pixel(-18.5, 13), shift),
						scale = 0.5,
					},
				},
				{
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "lights-1.png",
						width = 56,
						height = 42,
						line_length = 1,
						variation_count = 1,
						draw_as_light = true,
						shift = util.add_shift(util.by_pixel(-18, 13), shift),
						scale = 0.5,
					},
				},
			}
		end,
		slot_2 = function(shift, secondary_draw_order)
			---@type BeaconModuleVisualization[]
			return {
				{
					has_empty_slot = true,
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "slot-2.png",
						width = 46,
						height = 44,
						line_length = 2,
						variation_count = 2,
						shift = util.add_shift(util.by_pixel(19, -12), shift),
						scale = 0.5,
					},
				},
				{
					render_layer = "lower-object",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = box_folder .. "mask-box-2.png",
						width = 36,
						height = 28,
						line_length = 1,
						variation_count = 1,
						shift = util.add_shift(util.by_pixel(20.5, -12), shift),
						scale = 0.5,
					},
				},
				{
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "mask-lights-2.png",
						width = 24,
						height = 16,
						line_length = 1,
						variation_count = 1,
						shift = util.add_shift(util.by_pixel(21.5, -15.5), shift),
						scale = 0.5,
					},
				},
				{
					render_layer = "lower-object-above-shadow",
					secondary_draw_order = secondary_draw_order,
					pictures = {
						filename = folder .. "lights-2.png",
						width = 66,
						height = 46,
						line_length = 1,
						variation_count = 1,
						draw_as_light = true,
						shift = util.add_shift(util.by_pixel(22, -16), shift),
						scale = 0.5,
					},
				},
			}
		end,
	}
end

-- Where each pair of module slots sits, by the number of slots the beacon draws.
local SLOT_SHIFTS = {
	[2] = {
		{},
	},
	[4] = {
		-- Left and up, below the other pair.
		{ slot_1 = util.by_pixel(-3, -2.5), slot_2 = util.by_pixel(-8.5, -5.5) },
		-- Right and down, above the other pair.
		{ slot_1 = util.by_pixel(12, 5), slot_2 = util.by_pixel(2, 5) },
	},
	[6] = {
		-- Up, below all.
		{ slot_1 = util.by_pixel(-10.5, -11), slot_2 = util.by_pixel(7.5, -2) },
		-- Left, in the middle.
		{ slot_1 = util.by_pixel(-1.5, 7), slot_2 = util.by_pixel(-11, -6.5) },
		-- Right and down, above all.
		{ slot_1 = util.by_pixel(17, 3), slot_2 = util.by_pixel(4.5, 8) },
	},
}

---@param slot_count BeaconSlotCount
---@param creators BeaconModuleSlotCreators
---@return BeaconModuleVisualization[][]
---@nodiscard
local function get_module_slots(slot_count, creators)
	---@type BeaconModuleVisualization[][]
	local slots = {}

	for secondary_draw_order, shifts in pairs(SLOT_SHIFTS[slot_count]) do
		slots[#slots + 1] = creators.slot_1(shifts.slot_1 or { 0, 0 }, secondary_draw_order)
		slots[#slots + 1] = creators.slot_2(shifts.slot_2 or { 0, 0 }, secondary_draw_order)
	end

	return slots
end

---@param slot_count BeaconSlotCount
---@param art_styles BeaconModuleArtStyle[]?
---@return BeaconModuleVisualizations[]
---@nodiscard
local function get_module_visualisations(slot_count, art_styles)
	---@type BeaconModuleArtStyle[]
	local styles = {
		{ art_style = "vanilla", use_for_empty_slots = true, creators = M.module_slots.get_vanilla_creators() },
	}

	for _, art_style in pairs(art_styles or {}) do
		if art_style.art_style == "vanilla" then
			styles[1] = art_style
		else
			styles[#styles + 1] = art_style
		end
	end

	---@type BeaconModuleVisualizations[]
	local visualisations = {}

	for _, art_style in pairs(styles) do
		visualisations[#visualisations + 1] = {
			art_style = art_style.art_style,
			use_for_empty_slots = art_style.use_for_empty_slots,
			slots = get_module_slots(slot_count, art_style.creators),
		}
	end

	return visualisations
end

---@param tint Color?
---@return RotatedAnimationVariations
---@nodiscard
local function get_corpse_animation(tint)
	local remnants_folder = ASSETS_FOLDER .. "remnants/beacon-remnants-"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = BASE_FOLDER .. "remnants/beacon-remnants.png",
				direction_count = 1,
				width = 212,
				height = 206,
				shift = util.by_pixel(1, 5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(animation.layers--[[@cast -?]], {
			filename = remnants_folder .. "mask.png",
			direction_count = 1,
			width = 212,
			height = 206,
			shift = util.by_pixel(1, 5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast -?]], {
			filename = remnants_folder .. "highlights.png",
			direction_count = 1,
			width = 212,
			height = 206,
			shift = util.by_pixel(1, 5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return { animation, util.copy(animation) }
end

---@return WaterReflectionDefinition
---@nodiscard
local function get_water_reflection()
	return {
		pictures = {
			filename = BASE_FOLDER .. "beacon-reflection.png",
			priority = "extra-high",
			width = 18,
			height = 29,
			shift = util.by_pixel(0, 55),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---One art style the beacon draws its module slots in, and the creators drawing it.
---@class (exact) BeaconModuleArtStyle
---The name the beacon selects this art style by. Any name will do; the base game's own is `"vanilla"`.
---@field art_style string
---Whether this art style is drawn for slots holding no module.
---@field use_for_empty_slots boolean?
---The creators drawing the two module slots, from `beacon.module_slots`.
---@field creators BeaconModuleSlotCreators

---@class BeaconSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint Color?
---The number of module slots to draw. Buckets to the 2, 4, or 6 slot artwork; defaults to 2.
---@field slot_count integer?
---Additional art styles to draw the module slots in. The `"vanilla"` style is always drawn; naming one
---`"vanilla"` replaces it.
---@field module_art_styles BeaconModuleArtStyle[]?

local check_params = V.signature("get_sprite_set", {
	{
		"params",
		V.shape({
			tint = Common.color:optional(),
			slot_count = V.integer():positive():optional(),
			module_art_styles = V.array(V.shape({
				art_style = Common.non_empty_string,
				use_for_empty_slots = V.boolean():optional(),
				creators = module_slot_creators,
			})):optional(),
		}),
	},
})

---Gets the sprite set for the vanilla beacon.
---@param params BeaconSpriteSetParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<BeaconSpriteSet>
---
---#### Examples
---```lua
---local beacon = require("__reskins-assets-api__.assets.base.entities.beacon")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = beacon.get_sprite_set({
---    tint = tint,
---    slot_count = slot_count,
---    module_art_styles = {
---        { art_style = "bob-5-lights", creators = beacon.module_slots.get_tiered_creators(5) },
---    },
---})
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@nodiscard
function M.get_sprite_set(params)
	check_params(params)

	local slot_count = resolve_slot_count(params.slot_count)

	---@type AnimationElement[]
	local animation_list = {
		get_base_animation_element(slot_count, params.tint),
		get_antenna_top_animation_element(slot_count),
		get_light_animation_element(true),
		-- The base game draws the light twice, the second copy brightening the first.
		get_light_animation_element(false),
	}

	if slot_count == 4 then
		animation_list[#animation_list + 1] = get_4_slot_module_overlay()
	elseif slot_count == 6 then
		animation_list[#animation_list + 1] = get_6_slot_module_overlay(params.tint)
	end

	---@type SpriteSetDefinition<BeaconSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.beacon_sprite_set,
		set = {
			graphics_set = {
				animation_list = animation_list,
				module_visualisations = get_module_visualisations(slot_count, params.module_art_styles),
				animation_progress = 1,
				apply_module_tint = "secondary",
				module_icons_suppressed = true,
				module_tint_mode = "mix",
				no_modules_tint = { 1, 0, 0 },
				random_animation_offset = true,
			},
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil,
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = get_water_reflection(),
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local icons = IconCatalog:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla beacon, in the tints given by `params`.
M.get_icon = icons:tinted("beacon"):build("get_icon")

return M
