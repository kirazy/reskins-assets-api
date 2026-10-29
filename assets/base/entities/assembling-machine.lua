---@diagnostic disable: generic-constraint-mismatch

---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _constants = require("assets.constants")
local _pipes = require("assets.base.entities.pipe-pictures")
local _sprites = require("__reskins-sprite-utils__.sprites")
local V = require("__reskins-sprite-utils__.validation")

local IconBuilderFactory = require("api.icon-builder-factory")
local Common = require("__reskins-sprite-utils__.validation.common")

local M = {}

local check_get_graphics_set = V.signature("get_graphics_set", {
	{ "tint", Common.color:optional() },
	{ "assembly_set", V.one_of({ 1, 2, 3, 4, 5, 6 }) },
	{ "use_electronics_set", V.boolean():optional() },
})

local function get_circuit_connector()
	local base_path = "__base__/graphics/entity/assembling-machine-1/"
	return circuit_connector_definitions.create_vector({
		connector_main = util.sprite_load(base_path .. "assembling-machine-1-connection", {
			priority = "low",
			frame_count = 1,
			scale = 0.5,
		}),
		connector_shadow = util.sprite_load(base_path .. "assembling-machine-1-connection-shadow", {
			priority = "low",
			frame_count = 1,
			scale = 0.5,
			draw_as_shadow = true,
		}),
		led_blue = util.sprite_load(base_path .. "assembling-machine-1-connection-lights-blue", {
			priority = "low",
			frame_count = 1,
			scale = 0.5,
			draw_as_glow = true,
		}),
		led_green = util.sprite_load(base_path .. "assembling-machine-1-connection-lights-green", {
			priority = "low",
			frame_count = 1,
			scale = 0.5,
			draw_as_glow = true,
		}),
		led_red = util.sprite_load(base_path .. "assembling-machine-1-connection-lights-red", {
			priority = "low",
			frame_count = 1,
			scale = 0.5,
			draw_as_glow = true,
		}),
		wire_offsets = {
			{ red = util.by_pixel(25, 10), green = util.by_pixel(29, 8) },
		},
		wire_shadow_offsets = {
			{ red = util.by_pixel(60, 30), green = util.by_pixel(60, 29) },
		},
		light_offsets = {
			{ rg = util.by_pixel(0, 0), b = util.by_pixel(0, 0) },
		},
	}, {
		{ variation = 0, main_offset = util.by_pixel(0, 0), shadow_offset = util.by_pixel(0, 0), show_shadow = true },
		{ variation = 0, main_offset = util.by_pixel(0, 0), shadow_offset = util.by_pixel(0, 0), show_shadow = true },
		{ variation = 0, main_offset = util.by_pixel(0, 0), shadow_offset = util.by_pixel(0, 0), show_shadow = true },
		{ variation = 0, main_offset = util.by_pixel(0, 0), shadow_offset = util.by_pixel(0, 0), show_shadow = true },
	})
end

---@param tint? Color
---@param tier 1|2|3
---@return CraftingMachineGraphicsSet
---@nodiscard
local function get_assembler_graphics_set(tint, tier)
	local assets_path = "__reskins-assets-base__/graphics/entity/assembling-machine-" .. tier .. "/"
	local base_path = "__base__/graphics/entity/assembling-machine-" .. tier .. "/"

	---@type CraftingMachineGraphicsSet
	return {
		animation = {
			layers = {
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-base", {
					priority = "high",
					repeat_count = 64,
					scale = 0.5,
				}),
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-base-mask", {
					priority = "high",
					repeat_count = 64,
					tint = tint,
					scale = 0.5,
				}),
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-base-highlights", {
					priority = "high",
					repeat_count = 64,
					blend_mode = "additive-soft",
					scale = 0.5,
				}),
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-animation", {
					priority = "high",
					frame_count = 64,
					scale = 0.5,
				}),
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-animation-mask", {
					priority = "high",
					frame_count = 64,
					tint = tint,
					scale = 0.5,
				}),
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-animation-highlights", {
					priority = "high",
					frame_count = 64,
					blend_mode = "additive-soft",
					scale = 0.5,
				}),
				util.sprite_load(base_path .. "assembling-machine-" .. tier .. "-shadow", {
					priority = "high",
					frame_count = tier == 3 and 64 or nil,
					repeat_count = tier < 3 and 64 or nil,
					scale = 0.5,
					draw_as_shadow = true,
				}),
			},
		},
		working_visualisations = {
			{
				apply_tint = "status",
				always_draw = true,
				animation = util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-status-light", {
					priority = "high",
					draw_as_glow = true,
					blend_mode = "additive",
					scale = 0.5,
				}),
			},
			{
				always_draw = true,
				apply_tint = "status",
				light = { intensity = 0.2, size = 2, color = { r = 1, g = 1, b = 1 }, minimum_darkness = 0.1 },
				north_position = util.by_pixel(-32.0, 7.0),
				east_position = util.by_pixel(-32.0, 7.0),
				south_position = util.by_pixel(-32.0, 7.0),
				west_position = util.by_pixel(-32.0, 7.0),
			},
		},
		status_colors = _constants.get_status_colors(),
	}
end

---@param tint? Color
---@param tier 1|2|3
---@return Sprite4Way
---@nodiscard
local function get_assembler_pipe_pictures(tint, tier)
	local assets_path = "__reskins-assets-base__/graphics/entity/assembling-machine-" .. tier .. "/"

	---@type Sprite4Way
	return {
		north = {
			layers = {
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-pipe-north", {
					priority = "extra-high",
					scale = 0.5,
				}),
			},
		},
		east = {
			layers = {
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-pipe-east", {
					priority = "extra-high",
					scale = 0.5,
				}),
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-pipe-east-mask", {
					priority = "extra-high",
					tint = tint,
					scale = 0.5,
				}),
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-pipe-east-highlights", {
					priority = "extra-high",
					blend_mode = "additive-soft",
					scale = 0.5,
				}),
			},
		},
		south = {
			layers = {
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-pipe-south", {
					priority = "extra-high",
					scale = 0.5,
				}),
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-pipe-south-mask", {
					priority = "extra-high",
					tint = tint,
					scale = 0.5,
				}),
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-pipe-south-highlights", {
					priority = "extra-high",
					blend_mode = "additive-soft",
					scale = 0.5,
				}),
				_pipes.vertical_pipe_shadow({ 0, -1 }),
			},
		},
		west = {
			layers = {
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-pipe-west", {
					priority = "extra-high",
					scale = 0.5,
				}),
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-pipe-west-mask", {
					priority = "extra-high",
					tint = tint,
					scale = 0.5,
				}),
				util.sprite_load(assets_path .. "assembling-machine-" .. tier .. "-pipe-west-highlights", {
					priority = "extra-high",
					blend_mode = "additive-soft",
					scale = 0.5,
				}),
			},
		},
	}
end

---@param tint? Color
---@param tier 1|2|3
---@param draw_order? int8
---@return FluidBoxGraphics
local function get_fluid_box_graphics(tint, tier, draw_order)
	local pipe_pictures = get_assembler_pipe_pictures(tint, tier)

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

---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local sheet = {
		layers = {
			{
				filename = "__reskins-assets-assorted__/graphics/entity/assembling-machine-original/remnants/assembling-machine-remnants-base.png",
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
			filename = "__reskins-assets-assorted__/graphics/entity/assembling-machine-original/remnants/assembling-machine-remnants-mask.png",
			width = 328,
			height = 282,
			direction_count = 1,
			shift = util.by_pixel(0, 9.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(sheet.layers, {
			filename = "__reskins-assets-assorted__/graphics/entity/assembling-machine-original/remnants/assembling-machine-remnants-highlights.png",
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
			filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-reflection.png",
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

---The tier of an assembling machine, which selects its gear.
---@alias AssemblingMachineTier 1|2|3|4|5|6

---Defines the options for the assembling machine sprites.
---@class AssemblingMachineSpritesParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color
---The tier of the machine, which selects its gear.
---@field machine_tier AssemblingMachineTier
---When `true`, indicates that the electronics machine artwork is included. Default `false`.
---@field use_electronics_set? boolean
---When `true`, indicates that the simple pipe connections are included. Default `false`.
---@field use_simple_pipe_pictures? boolean

local check_params = V.signature("get_sprite_set", {
	{
		"params",
		V.struct({
			tint = Common.color:optional(),
			machine_tier = V.one_of({ 1, 2, 3, 4, 5, 6 }),
		}),
	},
})

local remapped_machine_tiers = {
	[1] = 1,
	[2] = 1,
	[3] = 2,
	[4] = 2,
	[5] = 3,
	[6] = 3,
}

---Gets the sprite set for the original standard assembling machine.
---@param params AssemblingMachineSpritesParams The options for the sprite set.
---@return SpriteSetDefinition<CraftingMachineSpriteSet> # The sprite set definition for the original standard assembling machine.
---
---#### Examples
---```lua
---local assembling_machine = require("__reskins-assets-api__.assets.assorted.entities.assembling-machine-original")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = assembling_machine.get_sprite_set({ tint = tint, machine_tier = 3 })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params.machine_tier` is not between 1 and 6.
---@throws When `params.tint` is not a `Color`.
---@throws When `params.use_electronics_set` or `params.use_simple_pipe_pictures` is not a boolean.
---@nodiscard
function M.get_sprite_set(params)
	check_params(params)

	local tier = remapped_machine_tiers[params.machine_tier]
	local graphics_set = get_assembler_graphics_set(params.tint, tier) --, params.machine_tier, params.use_electronics_set)

	-- Ensure fluid box pipe pictures draw over the mask and highlights.
	assert(graphics_set.animation and graphics_set.animation.layers)
	local draw_order = #graphics_set.animation.layers
	local fluid_box = get_fluid_box_graphics(params.tint, tier, draw_order) --, params.use_simple_pipe_pictures)

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

local base_icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })
local bobs_icons = IconBuilderFactory:create({ folder = "__reskins-assets-bobs__/graphics/icons" })

---Gets the icon for an assembling machine with the gear of the `machine_tier`, in the tints given by `params`.
M.get_icon = base_icons
	:tinted("assembling-machine")
	:keyed("machine_tier", V.one_of({ 1, 2, 3, 4, 5, 6 }), { "gear" })
	:layer("gear")
	:build("get_icon")

---Gets the icon for an electronics assembling machine with the indicator lights of the `electronics_tier`, in the
---tints given by `params`.
M.get_electronics_icon = bobs_icons
	:tinted("assembling-machine-electronics")
	:keyed("electronics_tier", V.one_of({ 1, 2, 3 }), { "lights" })
	:layer("lights")
	:build("get_electronics_icon")

---Gets the icon for a burner assembling machine, with its smoke stack, in the tints given by `params`.
M.get_burner_icon = bobs_icons:tinted("assembling-machine-burner"):layer("smoke-stack"):build("get_burner_icon")

---Gets the icon for a steam assembling machine, with its smoke stack, in the tints given by `params`. The smoke stack
---is tinted with the body.
M.get_steam_icon = bobs_icons:tinted("assembling-machine-steam"):tinted("smoke-stack"):build("get_steam_icon")

return M
