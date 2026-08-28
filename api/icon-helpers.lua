---@using data
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets

-- THIS MODULE IS EXTREMELY WIP AND SUBJECT TO CHANGE.
-- The type signatures are not stable.

---Creates a new icon with the specified `tint`, `shift`, and `scale`.
---
---*@param* `tint` — The color of the mask layer of the created icon; optional.
---
---*@param* `shift` — A shift to apply to every layer of the created icon; optional.
---
---*@param* `scale` — A scaling factor to apply to every layer of the created icon; optional.
---
---@alias TintedIconCreator fun(tint: Color?, shift: Vector?, scale: double?): IconData[]

---Creates a new icon with the specified `shift`, and `scale`.
---
---*@param* `shift` — A shift to apply to the created icon; optional.
---
---*@param* `scale` — A scaling factor to apply to the created icon; optional.
---
---@alias IconCreator fun(shift: Vector?, scale: double?): IconData[]

---Creates a new icon with the specified `shift`, and `scale`.
---
---*@param* `pipe_material` — The pipe material of the created icon.
---
---*@param* `shift` — A shift to apply to the created icon; optional.
---
---*@param* `scale` — A scaling factor to apply to the created icon; optional.
---
---@alias PipeIconCreator fun(pipe_material: PipeMaterial, shift: Vector?, scale: double?): IconData[]

---@alias RequiredAssets {[AssetsSource]: true}

local _assets = {
	defines = require("api.defines"),
	pipes = require("assets.base.entities.pipe-pictures"),
}
local _sprite_utils = {
	icons = require("__reskins-sprite-utils__.icons"),
	colors = require("__reskins-sprite-utils__.colors"),
	utils = require("__reskins-sprite-utils__.utils"),
}
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")

---@class Internal.PipeCreatableIcon
---@field type "pipe"|"pipe-to-ground"

---@class Internal.SimpleCreatableIcon
---@field folder string
---@field icon_name string
---@field icon_size SpriteSizeType?

---@class Internal.LayeredCreatableIcon:Internal.SimpleCreatableIcon
---@field icon_base string?
---@field icon_mask string?
---@field icon_highlights string?
---@field extras IconData[]?

---@class Internal.IconHelpers
local _helpers = {}

local SimpleCreatableIcon = V.shape({
	folder = Common.non_empty_string,
	icon_name = Common.non_empty_string,
	icon_size = Common.sprite_size:optional(),
}):describe_as("a SimpleCreatableIcon")

local LayeredCreatableIcon = V.shape({
	folder = Common.non_empty_string,
	icon_name = Common.non_empty_string,
	icon_size = Common.sprite_size:optional(),
	icon_base = Common.non_empty_string:optional(),
	icon_mask = Common.non_empty_string:optional(),
	icon_highlights = Common.non_empty_string:optional(),
	extras = Common.icon_data:optional(),
}):describe_as("a LayeredCreatableIcon")

local PipeCreatableIcon = V.shape({
	type = V.one_of({ "pipe", "pipe-to-ground" }),
}):describe_as("a PipeCreatableIcon")

local check_tinted_icon_creator = V.signature("tinted_icon_creator", {
	{ "tint", Common.color:optional() },
	{ "shift", Common.vector:optional() },
	{ "scale", Common.positive_number:optional() },
})

local check_icon_creator = V.signature("icon_creator", {
	{ "shift", Common.vector:optional() },
	{ "scale", Common.positive_number:optional() },
})

local check_pipe_icon_creator = V.signature("pipe_icon_creator", {
	{ "pipe_material", AssetsCommon.pipe_material },
	{ "shift", Common.vector:optional() },
	{ "scale", Common.positive_number:optional() },
})

---@class UntintedLayerParams
---@field folder string
---@field file_name string
---@field icon_size SpriteSizeType?
---@field tint Color?
---@field scale double?
---@field shift Vector?
---@field draw_background boolean?
---@field floating boolean?

---@class TintableLayerParams
---@field folder string
---@field file_name string
---@field icon_size SpriteSizeType?
---@field scale double?
---@field shift Vector?
---@field draw_background boolean?
---@field floating boolean?

---@class HighlightsLayerParams
---@field folder string
---@field file_name string
---@field icon_size SpriteSizeType?
---@field scale double?
---@field shift Vector?
---@field draw_background boolean?
---@field floating boolean?

-- GOTTA THINK ABOUT THIS. There's really just "one" layer builder, and a highlights one for convenience.

-- Keep it simple.
-- Layers are basically just the minimal definition, let transformation be handled by the transformer.
-- At most what is wanted is a concise way to create layered icons.

-- ---@param params UntintedLayerParams
-- ---@return fun(transform: IconTransform?): IconData
-- function _helpers.untinted_layer_fn(params)
-- 	return function(transform)
-- 		return _sprite_utils.icons.transform_icon({
-- 			icon = params.folder .. "/" .. params.file_name .. ".png",
-- 			icon_size = params.icon_size,
-- 			tint = params.tint,
-- 			shift = params.shift,
-- 			scale = params.scale,
-- 			draw_background = transform.draw_background ~= false and params.draw_background or transform.draw_background,
-- 			floating = transform.floating ~= false and params.floating or transform.floating,
-- 		}, transform.scale, transform.shift, transform.tint)
-- 	end
-- end

-- ---@param params TintableLayerParams
-- ---@return fun(tint: Color?, transform: IconTransform?): IconData
-- function _helpers.tinted_layer_fn(params)
-- 	return function(tint, transform)
-- 		---@cast tint Color?
-- 		---@cast transform IconTransform
-- 		transform = transform or {}

-- 		return _sprite_utils.icons.transform_icon({
-- 			icon = params.folder .. "/" .. params.file_name .. ".png",
-- 			icon_size = params.icon_size,
-- 			---@diagnostic disable-next-line: assign-type-mismatch NormalizedColor assigns to Color just fine, thanks.
-- 			tint = transform.tint and _sprite_utils.colors.blend(tint or { 1, 1, 1, 1 }, transform.tint) or tint,
-- 			shift = params.shift,
-- 			scale = params.scale,
-- 			draw_background = transform.draw_background ~= false and params.draw_background or transform.draw_background,
-- 			floating = transform.floating ~= false and params.floating or transform.floating,
-- 		}, transform.scale, transform.shift)
-- 	end
-- end

-- ---@param params HighlightsLayerParams
-- ---@return fun(transform: IconTransform?): IconData
-- function _helpers.highlights_layer_fn(params)
-- 	return function(transform)
-- 		return _sprite_utils.icons.transform_icon({
-- 			icon = params.folder .. "/" .. params.file_name .. ".png",
-- 			icon_size = params.icon_size,
-- 			tint = { 1, 1, 1, 0 },
-- 			shift = params.shift,
-- 			scale = params.scale,
-- 			draw_background = transform.draw_background ~= false and params.draw_background or transform.draw_background,
-- 			floating = transform.floating ~= false and params.floating or transform.floating,
-- 		}, transform.scale, transform.shift) -- Explicitly do not tint the highlights layer.
-- 	end
-- end

local check_make_tinted_three_layer_icon_creator_fn = V.signature("make_tinted_three_layer_icon_creator_fn", {
	{ "creatable_icon", LayeredCreatableIcon },
})

---Returns a function that when called with optional `tint`, `shift`, and `scale` parameters, will return a colored
---three-layer icon created using the provided `creatable_icon`.
---@param creatable_icon Internal.LayeredCreatableIcon Parameters that define the location of the sprites that comprise the icon.
---@return TintedIconCreator creator_fn
---
---### Exceptions
---*@throws* `string` — Thrown when `creatable_icon` does not name a `folder` and an `icon_name`, or carries an invalid `icon_size`, layer name, or `extras`.
function _helpers.make_tinted_three_layer_icon_creator_fn(creatable_icon)
	check_make_tinted_three_layer_icon_creator_fn(creatable_icon)

	local folder = creatable_icon.folder .. "/" .. creatable_icon.icon_name
	---@type TintedIconCreator
	local creator_fn = function(tint, shift, scale)
		check_tinted_icon_creator(tint, shift, scale)

		local transform = {
			shift = shift,
			scale = scale,
		}
		---@type IconData[]
		local icon_data = {
			{
				icon = folder .. "/" .. (creatable_icon.icon_base or creatable_icon.icon_name) .. "-icon-base.png",
				shift = shift,
				scale = scale,
			},
			{
				icon = folder .. "/" .. (creatable_icon.icon_mask or creatable_icon.icon_name) .. "-icon-mask.png",
				tint = tint,
				shift = shift,
				scale = scale,
			},
			{
				icon = folder .. "/" .. (creatable_icon.icon_highlights or creatable_icon.icon_name) .. "-icon-highlights.png",
				tint = { 1, 1, 1, 0 },
				shift = shift,
				scale = scale,
			},
		}

		if creatable_icon.extras then
			for _, extra in pairs(creatable_icon.extras) do
				local icon_datum = _sprite_utils.icons.transform_icon(extra, scale, shift, tint, "default")
				table.insert(icon_data, icon_datum)
			end
		end

		return _sprite_utils.icons.add_missing_icons_defaults(icon_data, "default")
	end

	return creator_fn
end

local check_make_tinted_circuit_icon_creator_fn = V.signature("make_tinted_circuit_icon_creator_fn", {
	{ "creatable_icon", SimpleCreatableIcon },
})

---Returns a function that when called with optional `tint`, `shift`, and `scale` parameters, will return a colored
---circuit icon created using the provided `creatable_icon`.
---@param creatable_icon Internal.SimpleCreatableIcon Parameters that define the location of the sprites that comprise the icon.
---@return TintedIconCreator creator_fn
---
---### Exceptions
---*@throws* `string` — Thrown when `creatable_icon` does not name a `folder` and an `icon_name`, or carries an invalid `icon_size`.
function _helpers.make_tinted_circuit_icon_creator_fn(creatable_icon)
	check_make_tinted_circuit_icon_creator_fn(creatable_icon)

	---@type TintedIconCreator
	local creator_fn = function(tint, shift, scale)
		check_tinted_icon_creator(tint, shift, scale)

		local folder = creatable_icon.folder .. "/" .. creatable_icon.icon_name
		---@type IconData[]
		local icon_data = {
			{
				icon = folder .. "/" .. creatable_icon.icon_name .. "-icon-base.png",
				tint = tint,
				shift = shift,
				scale = scale,
			},
			{
				icon = folder .. "/" .. creatable_icon.icon_name .. "-icon-highlights.png",
				shift = shift,
				scale = scale,
			},
			{
				icon = folder .. "/" .. creatable_icon.icon_name .. "-traces.png",
				shift = shift,
				scale = scale,
			},
		}

		return _sprite_utils.icons.add_missing_icons_defaults(icon_data, "default")
	end

	return creator_fn
end

local check_make_flat_icon_creator_fn = V.signature("make_flat_icon_creator_fn", {
	{ "creatable_icon", SimpleCreatableIcon },
})

---Returns a function that when called with optional `shift` and `scale` parameters, will return a
---flat icon using the provided `creatable_icon`.
---@param creatable_icon Internal.SimpleCreatableIcon Parameters that define the location of the sprites that comprise the icon.
---@return IconCreator
---
---### Exceptions
---*@throws* `string` — Thrown when `creatable_icon` does not name a `folder` and an `icon_name`, or carries an invalid `icon_size`.
function _helpers.make_flat_icon_creator_fn(creatable_icon)
	check_make_flat_icon_creator_fn(creatable_icon)

	---@type IconCreator
	local creator_fn = function(shift, scale)
		check_icon_creator(shift, scale)

		---@type IconData[]
		local icon_data = {
			{
				icon = creatable_icon.folder .. "/" .. creatable_icon.icon_name .. ".png",
				icon_size = creatable_icon.icon_size or defines.default_icon_size --[[@as SpriteSizeType]],
				shift = shift,
				scale = scale,
			},
		}

		return _sprite_utils.icons.add_missing_icons_defaults(icon_data)
	end

	return creator_fn
end

local check_make_pipe_icon_creator_fn = V.signature("make_pipe_icon_creator_fn", {
	{ "creatable_icon", PipeCreatableIcon },
})

---@param creatable_icon Internal.PipeCreatableIcon
---@return PipeIconCreator
---
---### Exceptions
---*@throws* `string` — Thrown when `creatable_icon.type` is not `"pipe"` or `"pipe-to-ground"`.
function _helpers.make_pipe_icon_creator_fn(creatable_icon)
	check_make_pipe_icon_creator_fn(creatable_icon)

	---@type PipeIconCreator
	local creator_fn = function(pipe_material, shift, scale)
		check_pipe_icon_creator(pipe_material, shift, scale)

		-- The iron pipe icon comes from base.
		local is_iron = pipe_material == _assets.defines.pipe_material.iron
		local material_asset = is_iron and _assets.defines.assets_source.base
			or _assets.pipes.asset_from_material(pipe_material)

		local material_name = _assets.pipes.name_from_material(pipe_material)
		local assets_base_path = material_asset .. "/graphics/icons/"

		local icon_name = is_iron and creatable_icon.type
			or creatable_icon.type .. "/" .. material_name .. "-" .. creatable_icon.type .. "-icon"
		---@type IconData[]
		local icon_data = {
			{
				icon = assets_base_path .. icon_name .. ".png",
				icon_size = 64,
				shift = shift,
				scale = scale,
			},
		}

		return _sprite_utils.icons.add_missing_icons_defaults(icon_data)
	end

	return creator_fn
end

return _helpers
