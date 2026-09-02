---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local _sprite_utils = { utils = require("__reskins-sprite-utils__.utils") }
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

local check_get_graphics_set = V.signature("get_graphics_set", {
	{ "tint", Common.color:optional() },
	{ "assembly_set", V.integer():in_range(1, 6) },
	{ "use_electronics_set", V.boolean():optional() },
})

---@param tint data.Color?
---@param assembly_set 1|2|3|4|5|6
---@param use_electronics_set boolean?
---@return data.CraftingMachineGraphicsSet
local function get_graphics_set(tint, assembly_set, use_electronics_set)
	check_get_graphics_set(tint, assembly_set, use_electronics_set)

	-- animations/shadows are 0-based.
	local animation_index = assembly_set - 1
	local shadow_index = math.min(4, animation_index)

	local assets_base_path = "__reskins-assets-base__/graphics/entity/assembling-machine/"

	---@type data.Animation
	local animation = {
		layers = {
			{
				filename = assets_base_path .. "assembling-machine-base.png",
				priority = "high",
				width = 214,
				height = 237,
				repeat_count = 32,
				shift = util.by_pixel(0, -0.75),
				scale = 0.5,
			},
		},
	}

	-- Increment the draw_order for use with fluid-boxes for every additional base-layer
	local draw_order = 1

	if tint then
		table.insert(animation.layers--[[@cast-?]], {
			filename = assets_base_path .. "assembling-machine-base-mask.png",
			priority = "high",
			width = 214,
			height = 237,
			repeat_count = 32,
			shift = util.by_pixel(0, -0.75),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers--[[@cast-?]], {
			filename = assets_base_path .. "assembling-machine-base-highlights.png",
			priority = "high",
			width = 214,
			height = 237,
			repeat_count = 32,
			shift = util.by_pixel(0, -0.75),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
		draw_order = draw_order + 2
	end

	table.insert(animation.layers--[[@cast-?]], {
		filename = assets_base_path .. "animations/assembling-machine-animation-" .. animation_index .. ".png",
		priority = "high",
		width = 214,
		height = 237,
		frame_count = 32,
		line_length = 8,
		shift = util.by_pixel(0, -0.75),
		scale = 0.5,
	})

	table.insert(animation.layers--[[@cast-?]], {
		filename = assets_base_path .. "shadows/assembling-machine-" .. shadow_index .. "-shadow.png",
		priority = "high",
		width = 264,
		height = 165,
		frame_count = 32,
		line_length = 8,
		draw_as_shadow = true,
		shift = util.by_pixel(27, 5),
		scale = 0.5,
	})

	if use_electronics_set then
		local assets_bobs_path = "__reskins-assets-bobs__/graphics/entity/assembling-machine-electronics/"
		table.insert(animation.layers--[[@cast-?]], {
			filename = assets_bobs_path .. "assembling-machine-electronics-base.png",
			priority = "high",
			width = 214,
			height = 237,
			repeat_count = 32,
			shift = util.by_pixel(0, -0.75),
			scale = 0.5,
		})
		draw_order = draw_order + 1
		if tint then
			table.insert(animation.layers--[[@cast-?]], {
				filename = assets_bobs_path .. "assembling-machine-electronics-mask.png",
				priority = "high",
				width = 214,
				height = 237,
				repeat_count = 32,
				shift = util.by_pixel(0, -0.75),
				tint = tint,
				scale = 0.5,
			})
			table.insert(animation.layers--[[@cast-?]], {
				filename = assets_bobs_path .. "assembling-machine-electronics-highlights.png",
				priority = "high",
				width = 214,
				height = 237,
				repeat_count = 32,
				shift = util.by_pixel(0, -0.75),
				blend_mode = "additive-soft",
				scale = 0.5,
			})
			draw_order = draw_order + 2
		end
		table.insert(animation.layers--[[@cast-?]], {
			filename = assets_bobs_path .. "assembling-machine-electronics-shadow.png",
			priority = "high",
			width = 264,
			height = 165,
			repeat_count = 32,
			draw_as_shadow = true,
			shift = util.by_pixel(27, 5),
			scale = 0.5,
		})
	end

	---@type data.CraftingMachineGraphicsSet
	return { animation = animation }
end

---@param tint data.Color?
---@param draw_order int8?
---@param use_simple_pipe_pictures boolean?
---@return FluidBoxGraphics
local function get_fluid_box_graphics(tint, draw_order, use_simple_pipe_pictures)
	local pipe_pictures = _pipes.assembling_machine_pipe_pictures(tint, use_simple_pipe_pictures)

	---@type FluidBoxGraphics
	return {
		pipe_covers = _pipes.pipe_covers(_defines.pipe_material.iron),
		pipe_picture = pipe_pictures,
		secondary_draw_orders = {
			north = -1,
			east = draw_order,
			south = draw_order,
			west = draw_order,
		},
	}
end

---@param tint data.Color?
---@return data.RotatedAnimationVariations
local function get_corpse_animation(tint)
	local sheet = {
		layers = {
			{
				filename = "__reskins-assets-base__/graphics/entity/assembling-machine/remnants/assembling-machine-remnants-base.png",
				width = 328,
				height = 282,
				direction_count = 1,
				shift = util.by_pixel(0, 9.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		table.insert(sheet.layers, {
			filename = "__reskins-assets-base__/graphics/entity/assembling-machine/remnants/assembling-machine-remnants-mask.png",
			width = 328,
			height = 282,
			direction_count = 1,
			shift = util.by_pixel(0, 9.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(sheet.layers, {
			filename = "__reskins-assets-base__/graphics/entity/assembling-machine/remnants/assembling-machine-remnants-highlights.png",
			width = 328,
			height = 282,
			direction_count = 1,
			shift = util.by_pixel(0, 9.5),
			blend_mode = "additive-soft",
			scale = 0.5,
		})
	end

	return _sprites.make_rotated_animation_variations_from_spritesheet(3, sheet)
end

---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__reskins-assets-base__/graphics/entity/assembling-machine/assembling-machine-reflection.png",
			priority = "extra-high",
			width = 24,
			height = 24,
			shift = util.by_pixel(5, 40),
			variation_count = 1,
			scale = 5,
		},
		rotate = false,
		orientation_to_variation = false,
	}
end

---@alias AssemblingMachineTier 1|2|3|4|5|6

---@class AssemblingMachineSpritesParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint data.Color?
---The tier of the machine, selecting the gear it is drawn with.
---@field machine_tier AssemblingMachineTier
---Whether to draw the electronics machine artwork. Defaults to `false`.
---@field use_electronics_set boolean?
---Whether to draw the simple pipe connections. Defaults to `false`.
---@field use_simple_pipe_pictures boolean?

local check_params = V.signature("get_sprite_set", {
	{
		"params",
		V.shape({
			tint = Common.color:optional(),
			machine_tier = V.integer():in_range(1, 6),
			use_electronics_set = V.boolean():optional(),
			use_simple_pipe_pictures = V.boolean():optional(),
		}),
	},
})

---Gets the sprite set for a standard assembling machine.
---@param params AssemblingMachineSpritesParams The options the sprite set is drawn with.
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---
---#### Examples
---```lua
---local assembling_machine = require("__reskins-assets-api__.assets.base.entities.assembling-machine")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = assembling_machine.get_sprite_set({ tint = tint, machine_tier = 3 })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws Thrown when `params.machine_tier` is not between 1 and 6.
---@throws Thrown when `params.tint` is not a `Color`.
---@throws Thrown when `params.use_electronics_set` or `params.use_simple_pipe_pictures` is not a boolean.
---@nodiscard
function M.get_sprite_set(params)
	check_params(params)

	local graphics_set = get_graphics_set(params.tint, params.machine_tier, params.use_electronics_set)

	-- Ensure fluid box pipe pictures draw over the mask and highlights.
	assert(graphics_set.animation and graphics_set.animation.layers)
	local draw_order = #graphics_set.animation.layers
	local fluid_box = get_fluid_box_graphics(params.tint, draw_order, params.use_simple_pipe_pictures)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			-- TODO: we need to a) setup the pipe picture sprites with tintable pipes, and b) take pipe tints
			graphics_set = graphics_set,
			fluid_boxes = { fluid_box },
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil, -- FIXME: type this and then build it out.
			corpse = { animation = get_corpse_animation(params.tint) },
			water_reflection = get_water_reflection(),
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

local BASE_ICON_FOLDER = "__reskins-assets-base__/graphics/icons/assembling-machine/"
local BOBS_ICON_FOLDER = "__reskins-assets-bobs__/graphics/icons/"

---The tier of an electronics assembling machine, selecting the indicator lights it is drawn with.
---@alias AssemblingMachineElectronicsTier 1|2|3

---Builds one icon layer from `icon`, at the size the artwork is drawn at.
---@param icon FileName The file the layer is drawn from.
---@param tint Color? The color to tint the layer.
---@return SafeIconData
---@nodiscard
local function get_layer(icon, tint)
	return {
		icon = icon,
		icon_size = 64,
		scale = 0.5,
		tint = tint,
	}
end

---Builds the base, mask, and highlights layers filed under `prefix`.
---@param prefix string The path the layers are filed under, up to the `-base`/`-mask`/`-highlights` suffix.
---@param tint Color? The color to tint the mask.
---@return SafeIconData[]
---@nodiscard
local function get_tinted_layers(prefix, tint)
	local layers = { get_layer(prefix .. "-base.png") }

	if tint then
		table.insert(layers, get_layer(prefix .. "-mask.png", tint))
		table.insert(layers, get_layer(prefix .. "-highlights.png", { 1, 1, 1, 0 }))
	end

	return layers
end

---The pieces the assembling machine icons are composed from, for building an icon this module
---doesn't already provide. Each comes back sized and scaled, ready for
---`icons.compose_icons` or `icons.transform_icon`.
---
---#### Examples
---```lua
---local assembling_machine = require("__reskins-assets-api__.assets.base.entities.assembling-machine")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---
------ The burner machine with a tier gear instead of its smoke stack.
---local layers = assembling_machine.icon_layers.burner_base(tint)
---table.insert(layers, assembling_machine.icon_layers.gear(3))
---```
M.icon_layers = {}

local check_base = V.signature("icon_layers.base", {
	{ "tint", Common.color:optional() },
})

---Gets the base, mask, and highlights layers of the standard assembling machine body, in the given
---`tint`.
---
---The standard machine has no additional layers, so these layers are also a complete icon.
---
---#### Parameters
---@param tint Color? The color to tint the mask. When `nil`, the tintable layers are omitted
---
---#### Returns
---@return SafeIconData[] # The layers of the standard machine body, sized and scaled.
---
---#### Examples
---```lua
---local assembling_machine = require("__reskins-assets-api__.assets.base.entities.assembling-machine")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---
---local icon = assembling_machine.icon_layers.base(tint)
---sprite_utils_icons.assign_icons_to_prototype_and_related_prototypes(entity.name, entity.type, icon)
---```
---@throws Thrown when `tint` is not a `Color`.
---@nodiscard
function M.icon_layers.base(tint)
	check_base(tint)

	return get_tinted_layers(BASE_ICON_FOLDER .. "assembling-machine-icon", tint)
end

local check_electronics_base = V.signature("icon_layers.electronics_base", {
	{ "tint", Common.color:optional() },
})

---Gets the base, mask, and highlights layers of the electronics assembling machine body, in the
---given `tint`.
---
---The body of the electronics machine is not a complete icon; it is drawn with its indicator
---lights.
---
---#### Parameters
---@param tint Color? The color to tint the mask. When `nil`, the tintable layers are omitted
---
---#### Returns
---@return SafeIconData[] # The layers of the electronics machine body, sized and scaled.
---
---#### Examples
---Draw the electronics machine body with a custom layer.
---```lua
---local assembling_machine = require("__reskins-assets-api__.assets.base.entities.assembling-machine")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---
---local icon = sprite_utils_icons.compose_icons("default", assembling_machine.icon_layers.electronics_base(tint), my_layer)
---```
---@throws Thrown when `tint` is not a `Color`.
---@nodiscard
function M.icon_layers.electronics_base(tint)
	check_electronics_base(tint)

	return get_tinted_layers(
		BOBS_ICON_FOLDER .. "assembling-machine-electronics/assembling-machine-electronics-icon",
		tint
	)
end

local check_burner_base = V.signature("icon_layers.burner_base", {
	{ "tint", Common.color:optional() },
})

---Gets the base, mask, and highlights layers of the burner assembling machine body, in the given
---`tint`.
---
---#### Parameters
---@param tint Color? The color to tint the mask. When `nil`, the tintable layers are omitted
---
---#### Returns
---@return SafeIconData[] # The layers of the burner machine body, sized and scaled.
---@throws Thrown when `tint` is not a `Color`.
---@nodiscard
function M.icon_layers.burner_base(tint)
	check_burner_base(tint)

	return get_tinted_layers(BOBS_ICON_FOLDER .. "assembling-machine-burner/assembling-machine-burner-icon", tint)
end

local check_steam_base = V.signature("icon_layers.steam_base", {
	{ "tint", Common.color:optional() },
})

---Gets the base, mask, and highlights layers of the steam assembling machine body, in the given
---`tint`.
---
---#### Parameters
---@param tint Color? The color to tint the mask. When `nil`, the tintable layers are omitted
---
---#### Returns
---@return SafeIconData[] # The layers of the steam machine body, sized and scaled.
---@throws Thrown when `tint` is not a `Color`.
---@nodiscard
function M.icon_layers.steam_base(tint)
	check_steam_base(tint)

	return get_tinted_layers(BOBS_ICON_FOLDER .. "assembling-machine-steam/assembling-machine-steam-icon", tint)
end

local check_gear = V.signature("icon_layers.gear", {
	{ "machine_tier", V.integer():in_range(1, 6) },
})

---Gets the gear layer of a standard assembling machine of the given `machine_tier`.
---@param machine_tier AssemblingMachineTier The tier of the machine, selecting the gear layer.
---@return SafeIconData # The gear layer, sized and scaled.
---
---#### Examples
---Put the gear in the corner of an icon of your own.
---```lua
---local assembling_machine = require("__reskins-assets-api__.assets.base.entities.assembling-machine")
---local sprite_utils_icons = require("__reskins-sprite-utils__.icons")
---
---local gear = sprite_utils_icons.transform_icon(assembling_machine.icon_layers.gear(3), { scale = 0.5, shift = { 8, 8 } })
---local icon = sprite_utils_icons.compose_icons("default", my_icon, { gear })
---```
---@throws Thrown when `machine_tier` is not between 1 and 6.
---@nodiscard
function M.icon_layers.gear(machine_tier)
	check_gear(machine_tier)

	return get_layer(BASE_ICON_FOLDER .. "gear-" .. (machine_tier - 1) .. ".png")
end

local check_electronics = V.signature("icon_layers.electronics", {
	{ "electronics_tier", V.integer():in_range(1, 3) },
})

---Gets the indicator lights layer of an electronics assembling machine of the given
---`electronics_tier`.
---@param electronics_tier AssemblingMachineElectronicsTier The tier of the machine, selecting the lights layer.
---@return SafeIconData # The indicator lights layer, sized and scaled.
---@throws Thrown when `electronics_tier` is not between 1 and 3.
---@nodiscard
function M.icon_layers.electronics(electronics_tier)
	check_electronics(electronics_tier)

	return get_layer(BOBS_ICON_FOLDER .. "assembling-machine-electronics/electronics-" .. electronics_tier .. ".png")
end

---Gets the smoke stack layer of a burner assembling machine.
---@return SafeIconData # The smoke stack layer, sized and scaled.
---@nodiscard
function M.icon_layers.smoke_stack()
	return get_layer(BOBS_ICON_FOLDER .. "assembling-machine-burner/smoke-stack.png")
end

local check_steam_smoke_stack = V.signature("icon_layers.steam_smoke_stack", {
	{ "tint", Common.color:optional() },
})

---Gets the base, mask, and highlights layers of the smoke stack of a steam assembling machine, in
---the given `tint`.
---
---The smoke stack of the steam machine includes a pipe connection, and is tinted as a machine body
---is. The smoke stack of the burner machine is a single layer.
---
---#### Parameters
---@param tint Color? The color to tint the mask. When `nil`, the tintable layers are omitted
---
---#### Returns
---@return SafeIconData[] # The layers of the smoke stack, sized and scaled.
---@throws Thrown when `tint` is not a `Color`.
---@nodiscard
function M.icon_layers.steam_smoke_stack(tint)
	check_steam_smoke_stack(tint)

	return get_tinted_layers(BOBS_ICON_FOLDER .. "assembling-machine-steam/steam-smoke-stack", tint)
end

local check_get_icon = V.signature("get_icon", {
	{ "machine_tier", V.integer():in_range(1, 6) },
	{ "tint", Common.color:optional() },
})

---Gets the icon for a standard assembling machine with the gear for the given
---
---#### Parameters
---@param machine_tier AssemblingMachineTier The tier of the machine, selecting the gear it is drawn with.
---@param tint Color? The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_icon(machine_tier, tint)
	check_get_icon(machine_tier, tint)

	return _sprite_utils.utils.array_concat(M.icon_layers.base(tint), { M.icon_layers.gear(machine_tier) })
end

local check_get_electronics_icon = V.signature("get_electronics_icon", {
	{ "electronics_tier", V.integer():in_range(1, 3) },
	{ "tint", Common.color:optional() },
})

---Gets the icon for an electronics assembling machine with the indicator lights for
---
---The artwork is scaled down (4/5th scale) from the reference assembling machine icon, as the electronics machine it
---was intended for is a mini machine by definition, and so the icon is drawn at that size.
---
---#### Parameters
---@param electronics_tier AssemblingMachineElectronicsTier The tier of the machine, selecting the indicator lights it is drawn with.
---@param tint Color? The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_electronics_icon(electronics_tier, tint)
	check_get_electronics_icon(electronics_tier, tint)

	return _sprite_utils.utils.array_concat(
		M.icon_layers.electronics_base(tint),
		{ M.icon_layers.electronics(electronics_tier) }
	)
end

local check_get_burner_icon = V.signature("get_burner_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for a burner assembling machine, with its smoke stack, in the given `tint`.
---
---#### Parameters
---@param tint Color? The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_burner_icon(tint)
	check_get_burner_icon(tint)

	return _sprite_utils.utils.array_concat(M.icon_layers.burner_base(tint), { M.icon_layers.smoke_stack() })
end

local check_get_steam_icon = V.signature("get_steam_icon", {
	{ "tint", Common.color:optional() },
})

---Gets the icon for a steam assembling machine, with its smoke stack, in the given `tint`.
---
---#### Parameters
---@param tint Color? The color to tint the icon. When `nil`, the tintable layers are omitted.
---@return SafeIconData[]
---@nodiscard
function M.get_steam_icon(tint)
	check_get_steam_icon(tint)

	return _sprite_utils.utils.array_concat(M.icon_layers.steam_base(tint), M.icon_layers.steam_smoke_stack(tint))
end

return M
