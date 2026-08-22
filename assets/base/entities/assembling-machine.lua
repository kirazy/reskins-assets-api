---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local _pipes = require("assets.base.entities.pipe-pictures")
local _sprites = require("__reskins-sprite-utils__.sprites")

-- FIXME: replace this with the tools from SpriteUtils.Validation.
local NumberValidator = require("prototypes.number-validator")

local M = {}

---@param tint data.Color?
---@param assembly_set 1|2|3|4|5|6
---@param use_electronics_set boolean?
---@return data.CraftingMachineGraphicsSet
local function get_graphics_set(tint, assembly_set, use_electronics_set)
	NumberValidator.validate(assembly_set, "assembly_set"):is_integer():in_range(1, 6)

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
	return _sprites.make_rotated_animation_variations_from_spritesheet(3, {
		layers = {
			{
				filename = "__reskins-assets-base__/graphics/entity/assembling-machine/remnants/assembling-machine-remnants-base.png",
				width = 328,
				height = 282,
				direction_count = 1,
				shift = util.by_pixel(0, 9.5),
				scale = 0.5,
			},
			{
				filename = "__reskins-assets-base__/graphics/entity/assembling-machine/remnants/assembling-machine-remnants-mask.png",
				width = 328,
				height = 282,
				direction_count = 1,
				shift = util.by_pixel(0, 9.5),
				tint = tint,
				scale = 0.5,
			},
			{
				filename = "__reskins-assets-base__/graphics/entity/assembling-machine/remnants/assembling-machine-remnants-highlights.png",
				width = 328,
				height = 282,
				direction_count = 1,
				shift = util.by_pixel(0, 9.5),
				blend_mode = "additive-soft",
				scale = 0.5,
			},
		},
	})
end

---@class AssemblingMachineSpritesParams
---@field tint data.Color?
---@field machine_tier 1|2|3|4|5|6
---@field use_electronics_set boolean?
---@field use_simple_pipe_pictures boolean?

---Produces the sprite set for a standard assembling machine.
---
---A pure function of `params` — does not read or touch any prototype. `entity_sprites` is
---tagged `crafting_machine_graphics_set` and can be handed to `graphics-packs.apply`, which routes
---to the applicator for whatever `prototype`'s own type actually is (or, to force a specific
---applicator regardless of `prototype.type`, call `graphics-packs.apply.applicators.crafting_machine`
---directly) — this file only knows how to build the sprite data, not how to place it on a
---prototype.
---
---### Examples
---```lua
---local assembling_machine = require("assets.base.entities.assembling-machine")
---local apply = require("graphics-packs.apply")
---
---local sprites = assembling_machine.get({ tint = tint, machine_tier = 3 })
---apply.apply(entity, sprites.entity_sprites)
---```
---@param params AssemblingMachineSpritesParams
---@return SpriteSetDefinition<CraftingMachineSpriteSet>
---@nodiscard
function M.get(params)
	local graphics_set = get_graphics_set(params.tint, params.machine_tier, params.use_electronics_set)

	-- Ensure fluid box pipe pictures draw over the mask and highlights.
	assert(graphics_set.animation and graphics_set.animation.layers)
	local draw_order = #graphics_set.animation.layers
	local fluid_box = get_fluid_box_graphics(params.tint, draw_order, params.use_simple_pipe_pictures)

	---@type SpriteSetDefinition<CraftingMachineSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.crafting_machine_sprite_set,
		set = {
			-- FIXME: we need to a) setup the pipe picture sprites with tintable pipes, and b) take pipe tints
			graphics_set = graphics_set,
			fluid_boxes = { fluid_box },
			integration_patch = nil,
			integration_patch_render_layer = nil,
			dying_explosion = nil, -- FIXME: type this and then build it out.
			corpse = get_corpse_animation(params.tint),
			water_reflection = nil, -- FIXME: set this.
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

return M
