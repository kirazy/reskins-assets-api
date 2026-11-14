---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local _defines = require("api.defines")
local IconBuilderFactory = require("api.icon-builder-factory")
local _sprite_utils = { sprites = require("__reskins-sprite-utils__.sprites") }

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")
local Corpses = require("api.corpses")
local Explosions = require("api.explosions")
local LabExplosion = require("assets.base.explosions.lab")
local Remnants = require("assets.base.remnants")

local M = {}

---@param tint? Color
---@return Animation
local function get_on_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/lab/"
	local base_path = _defines.assets_source.base .. "/graphics/entity/lab/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "lab.png",
				width = 194,
				height = 174,
				frame_count = 33,
				line_length = 11,
				animation_speed = 1 / 3,
				shift = util.by_pixel(0, 1.5),
				scale = 0.5,
			},
			{
				filename = base_path .. "lab-light.png",
				width = 216,
				height = 194,
				repeat_count = 33,
				animation_speed = 1 / 3,
				blend_mode = "additive",
				draw_as_light = true,
				shift = util.by_pixel(0, 0),
				scale = 0.5,
			},
			{
				filename = base_path .. "lab-shadow.png",
				width = 242,
				height = 136,
				repeat_count = 33,
				animation_speed = 1 / 3,
				draw_as_shadow = true,
				shift = util.by_pixel(13, 11),
				scale = 0.5,
			},
		},
	}

	if tint then
		---@cast animation.layers -?
		table.insert(animation.layers, {
			filename = assets_path .. "lab-mask.png",
			width = 194,
			height = 174,
			frame_count = 33,
			line_length = 11,
			animation_speed = 1 / 3,
			tint = tint,
			shift = util.by_pixel(0, 1.5),
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "lab-highlights.png",
			width = 194,
			height = 174,
			frame_count = 33,
			line_length = 11,
			animation_speed = 1 / 3,
			blend_mode = "additive",
			shift = util.by_pixel(0, 1.5),
			scale = 0.5,
		})
	end

	return animation
end

---Gets the still mask and highlights of the lab, with the mask in the given `tint`.
---@param tint Color
---@return Animation[]
local function get_still_mask_layers(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/lab/"

	return {
		{
			filename = assets_path .. "lab-mask.png",
			width = 194,
			height = 174,
			tint = tint,
			shift = util.by_pixel(0, 1.5),
			scale = 0.5,
		},
		{
			filename = assets_path .. "lab-highlights.png",
			width = 194,
			height = 174,
			blend_mode = "additive",
			shift = util.by_pixel(0, 1.5),
			scale = 0.5,
		},
	}
end

---@param tint? Color
---@return Animation
local function get_off_animation(tint)
	local base_path = _defines.assets_source.base .. "/graphics/entity/lab/"

	---@type Animation
	local animation = {
		layers = {
			{
				filename = base_path .. "lab.png",
				width = 194,
				height = 174,
				shift = util.by_pixel(0, 1.5),
				scale = 0.5,
			},
			{
				filename = base_path .. "lab-shadow.png",
				width = 242,
				height = 136,
				draw_as_shadow = true,
				shift = util.by_pixel(13, 11),
				scale = 0.5,
			},
		},
	}

	if tint then
		---@cast animation.layers -?
		for _, layer in pairs(get_still_mask_layers(tint)) do
			table.insert(animation.layers, layer)
		end
	end

	return animation
end

---Gets the frozen patch of the lab, when the freezing feature is enabled and Space Age is loaded.
---@return Sprite?
local function get_frozen_patch()
	if not (feature_flags["freezing"] and mods["space-age"]) then
		return nil
	end

	return {
		filename = "__space-age__/graphics/entity/frozen/lab/lab.png",
		width = 194,
		height = 174,
		shift = util.by_pixel(0, 1.5),
		scale = 0.5,
	}
end

---@return Sprite
local function get_integration_patch()
	---@type Sprite
	local patch = {
		filename = "__base__/graphics/entity/lab/lab-integration.png",
		width = 242,
		height = 162,
		shift = util.by_pixel(0, 15.5),
		scale = 0.5,
	}
	return patch
end

---@return WaterReflectionDefinition
local function get_water_reflection()
	return {
		pictures = {
			filename = "__reskins-assets-base__/graphics/entity/lab/lab-reflection.png",
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

---@param tint? Color
---@return RotatedAnimationVariations
local function get_corpse_animation(tint)
	local assets_path = _defines.assets_source.base_assets .. "/graphics/entity/lab/remnants/"
	local base_path = _defines.assets_source.base .. "/graphics/entity/lab/remnants/"

	---@type RotatedAnimation
	local animation = {
		layers = {
			{
				filename = base_path .. "lab-remnants.png",
				line_length = 1,
				width = 266,
				height = 196,
				direction_count = 1,
				shift = util.by_pixel(7, 5.5),
				scale = 0.5,
			},
		},
	}

	if tint then
		---@cast animation.layers -?
		table.insert(animation.layers, {
			filename = assets_path .. "lab-remnants-mask.png",
			line_length = 1,
			width = 266,
			height = 196,
			direction_count = 1,
			shift = util.by_pixel(7, 5.5),
			tint = tint,
			scale = 0.5,
		})
		table.insert(animation.layers, {
			filename = assets_path .. "lab-remnants-highlights.png",
			line_length = 1,
			width = 266,
			height = 196,
			direction_count = 1,
			shift = util.by_pixel(7, 5.5),
			blend_mode = "additive",
			scale = 0.5,
		})
	end

	return _sprite_utils.sprites.make_rotated_animation_variations_from_spritesheet(2, animation)
end

---Gets the circuit connector of the lab.
---@return CircuitConnectorDefinition
local function get_circuit_connector()
	---@diagnostic disable-next-line: param-type-mismatch
	return circuit_connector_definitions.create_single(universal_connector_template, {
		variation = 27,
		main_offset = util.by_pixel(30, 24),
		shadow_offset = util.by_pixel(35, 32),
		show_shadow = true,
	})
end

---Defines the options for the vanilla lab sprite set.
---@class LabSpriteSetParams
---The color to tint the artwork. When `nil`, the tintable layers are omitted from the set.
---@field tint? Color

local check_get_sprite_set = V.signature("get_sprite_set", {
	{
		"params",
		V.class("LabSpriteSetParams", {
			tint = Common.color:optional(),
		}):strict(),
	},
})

---Gets the sprite set for the vanilla lab.
---
---The frozen patch is included when the freezing feature is enabled and Space Age is loaded.
---@param params LabSpriteSetParams The options for the sprite set.
---@return SpriteSetDefinition<LabSpriteSet> # The sprite set definition for the vanilla lab.
---
---#### Examples
---```lua
---local lab = require("__reskins-assets-api__.assets.base.entities.lab")
---local applicators = require("__reskins-assets-api__.api.applicators")
---
---local sprite_set = lab.get_sprite_set({ tint = tint })
---applicators.apply_sprite_set(entity, sprite_set)
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_sprite_set(params)
	check_get_sprite_set(params)

	---@type SpriteSetDefinition<LabSpriteSet>
	local definition = {
		set_type = _defines.sprite_set_type.lab_sprite_set,
		set = {
			on_animation = get_on_animation(params.tint),
			off_animation = get_off_animation(params.tint),
			frozen_patch = get_frozen_patch(),
			integration_patch = get_integration_patch(),
			integration_patch_render_layer = nil,
			dying_explosion = LabExplosion.get_explosion({
				tints = params.tint and { ["lab-metal-particle-big"] = params.tint },
			}),
			corpse = Remnants.get_corpse("lab-remnants", { animation = get_corpse_animation(params.tint) }),
			water_reflection = get_water_reflection(),
			circuit_connector = get_circuit_connector(),
			nominal_width = 3,
			nominal_height = 3,
		},
	}

	return definition
end

---Gets the frozen patch of the vanilla lab.
---@return Sprite? # The frozen patch, or `nil` when the freezing feature is disabled or Space Age is not loaded.
---@nodiscard
function M.get_frozen_patch()
	return get_frozen_patch()
end

---Defines the options for the mask of the vanilla lab.
---@class LabMaskParams
---The color to tint the mask.
---@field tint Color

local check_get_mask_layers = V.signature("get_mask_layers", {
	{
		"params",
		V.class("LabMaskParams", {
			tint = Common.color,
		}):strict(),
	},
})

---Gets the still mask and highlights of the vanilla lab, in the tint given by `params`, to draw over another lab with
---the same geometry.
---@param params LabMaskParams The options for the mask.
---@return Animation[] # The mask and the highlights, in that order.
---
---#### Examples
---```lua
----- Draw the mask of the lab over the artwork of another lab.
---local lab = require("__reskins-assets-api__.assets.base.entities.lab")
---
---local layers = { artwork }
---for _, layer in pairs(lab.get_mask_layers({ tint = tint })) do
---    layers[#layers + 1] = layer
---end
---```
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@nodiscard
function M.get_mask_layers(params)
	check_get_mask_layers(params)

	return get_still_mask_layers(params.tint)
end

---The width and height of a frame of the lab, in pixels.
local FRAME_WIDTH, FRAME_HEIGHT = 194, 174

---The number of frames in the animation of the lab, and the number of frames in each row of its sheet.
local FRAME_COUNT, LINE_LENGTH = 33, 11

---Indicates whether the given `layer` has the frame size of the lab and is not drawn as a light.
---@param layer table
---@return boolean
local function is_lab_frame(layer)
	return layer.width == FRAME_WIDTH and layer.height == FRAME_HEIGHT and not layer.draw_as_light
end

---Gets the mask and highlights of the lab in the given `tint`, drawn with the shift and the frames of the given
---artwork `layer`.
---@param layer table The artwork, with the frame size of the lab.
---@param tint Color The color of the mask.
---@return Animation[]
local function get_mask_layers_for(layer, tint)
	local frame_count = layer.frame_count or 1
	if frame_count ~= 1 and (frame_count ~= FRAME_COUNT or layer.line_length ~= LINE_LENGTH) then
		error(
			string.format(
				"The artwork '%s' has %d frames in rows of %s, and the mask of the lab has %d frames in rows of %d.",
				tostring(layer.filename),
				frame_count,
				tostring(layer.line_length),
				FRAME_COUNT,
				LINE_LENGTH
			)
		)
	end

	local layers = get_still_mask_layers(tint)
	for _, mask_layer in pairs(layers) do
		mask_layer.shift = util.copy(layer.shift)
		if frame_count ~= 1 then
			mask_layer.frame_count = FRAME_COUNT
			mask_layer.line_length = LINE_LENGTH
			mask_layer.animation_speed = layer.animation_speed
		end
	end

	return layers
end

---Adds the mask and highlights of the lab in the given `tint` over the first layer of the given `animation` in place,
---when that layer has the frame size of the lab. An animation with a single layer is given `layers`, with that layer
---first, when the mask is added.
---@param animation table The animation, with a single layer or with `layers`.
---@param tint Color The color of the mask.
---@return boolean # `true` when the mask is added; otherwise, `false`.
local function add_mask_to_animation(animation, tint)
	local first_layer = animation.layers and animation.layers[1] or animation
	if not is_lab_frame(first_layer) then
		return false
	end

	if not animation.layers then
		local layer = util.copy(animation)
		for key in pairs(layer) do
			animation[key] = nil
		end
		animation.layers = { layer }
	end

	local layers = animation.layers
	for offset, mask_layer in pairs(get_mask_layers_for(layers[1], tint)) do
		table.insert(layers, 1 + offset, mask_layer)
	end

	return true
end

---Adds the mask and highlights of the lab in the given `tint` over the given `animation` in place, for each direction
---when it has directions.
---@param animation table The animation, or the animation for each direction.
---@param tint Color The color of the mask.
---@return boolean # `true` when the mask is added; otherwise, `false`.
local function add_mask_to_any_animation(animation, tint)
	if not (animation.north or animation.east or animation.south or animation.west) then
		return add_mask_to_animation(animation, tint)
	end

	local is_added = false
	for _, direction in pairs({ "north", "east", "south", "west" }) do
		if animation[direction] then
			is_added = add_mask_to_animation(animation[direction], tint) or is_added
		end
	end

	return is_added
end

local check_apply_mask = V.signature("apply_mask", {
	{
		"prototype",
		AssetsCommon.prototype:where(function(value)
			return value.type == "lab" or value.graphics_set ~= nil
		end, "is neither a lab nor a crafting machine with a graphics set"),
	},
	{
		"params",
		V.class("LabMaskParams", {
			tint = Common.color,
		}):strict(),
	},
})

---Adds the mask and highlights of the vanilla lab in the tint given by `params` over the artwork of the given
---`prototype`, and creates its remnants and dying explosion from the vanilla lab in that tint, in place. The artwork of
---`prototype` is otherwise not modified.
---
---- For a lab, the mask is added over the first layer of `on_animation` and of `off_animation`.
---- For a crafting machine, the mask is added over the first layer of `graphics_set.animation`, and over the first
---  layer of each working visualisation in `graphics_set.working_visualisations` in which that layer has the frame
---  size of the lab and is not drawn as a light.
---- The mask is drawn with the shift of the layer, and with the frames of the layer when it has frames. An animation
---  with a single layer is given `layers`, with that layer first.
---- The remnants are created as `ar-<entity name>-remnants` and the dying explosion as `ar-<entity name>-explosion`,
---  and both are set on `prototype`.
---@param prototype LabPrototype|CraftingMachinePrototype The lab, or a crafting machine with artwork in the frame size of the lab.
---@param params LabMaskParams The options for the mask.
---
---#### Examples
---```lua
----- Draw a lab of another mod in the tint of tier 2.
---local lab = require("__reskins-assets-api__.assets.base.entities.lab")
---local tint = { r = 0.9, g = 0.2, b = 0.2 }
---
---lab.apply_mask(data.raw["lab"]["lab-2"], { tint = tint })
----- The mask and highlights are drawn over the on and off animations of "lab-2", which uses the remnants and the dying
----- explosion of the lab in `tint`.
---```
---@throws When `prototype` is neither a lab nor a crafting machine with a graphics set.
---@throws When `params` defines an unrecognized field.
---@throws When `params.tint` is not a `Color`.
---@throws When the first layer of an animation that the mask is drawn over does not have the frame size of the lab.
---@throws When the first layer of an animation that the mask is drawn over has frames that are not those of the lab.
---@see Applicators.apply_sprite_set
---@see Corpses.apply
---@see Explosions.apply
function M.apply_mask(prototype, params)
	check_apply_mask(prototype, params)

	local tint = params.tint

	---@type table[]
	local animations = {}
	if prototype.type == "lab" then
		animations = { prototype.on_animation, prototype.off_animation }
	else
		animations = { prototype.graphics_set.animation }
	end

	for _, animation in pairs(animations) do
		if not add_mask_to_any_animation(animation, tint) then
			error(string.format("The artwork of '%s' does not have the frame size of the lab.", prototype.name))
		end
	end

	if prototype.type ~= "lab" then
		for _, visualisation in pairs(prototype.graphics_set.working_visualisations or {}) do
			for _, field in pairs({ "animation", "north_animation", "east_animation", "south_animation", "west_animation" }) do
				if visualisation[field] then
					add_mask_to_animation(visualisation[field], tint)
				end
			end
		end
	end

	local set = M.get_sprite_set({ tint = tint }).set
	Corpses.apply(prototype, set.corpse)
	Explosions.apply(prototype, set.dying_explosion)
end

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

local icon_builder = icons:tinted("lab")

---Gets the icon for the vanilla lab, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for the vanilla lab as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

---Gets the mask and highlights of the icon for the vanilla lab as an `IconComposition`, in the tint given by `params`,
---to draw over another lab icon with the same geometry.
M.get_mask_icon_composition = icons:layers("lab"):mask():highlights():build_composition("get_mask_icon_composition")

return M
