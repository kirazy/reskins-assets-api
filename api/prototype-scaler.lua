---@using data

---@namespace Reskins.Assets

local _sprite_utils = { sprites = require("__reskins-sprite-utils__.sprites") }
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")

---The scale for which the artwork in the assets mods are designed. An explicit `scale` is relative to this value; a
---`scale` equal to the baseline is a factor of 1.
local BASELINE_SCALE = 0.5

---The difference between the width and height ratios, relative to the larger, above which a mismatch of aspect ratios
---is logged.
local ASPECT_RATIO_TOLERANCE = 0.05

---Represents a scaling relationship that is determined once for a prototype and a nominal size, and that can be applied
---any number of times to any prototype or part of a prototype.
---
---The scale factor is resolved when the scaler is created, from the first of these sources that applies:
---1. An explicit `scale_factor`, or an explicit `scale` relative to the baseline of 0.5.
---2. The largest factor at which the nominal size fits within the `selection_box` of the prototype.
---
---#### Examples
---```lua
---local PrototypeScaler = require("__reskins-assets-api__.api.prototype-scaler")
---```
---@class PrototypeScaler
---The uniform scale factor.
---@field private scalar double
local PrototypeScaler = {}
PrototypeScaler.__index = PrototypeScaler

---Gets the width and height of the given bounding box, in either the named or the array form.
---@param bounding_box BoundingBox
---@return double width
---@return double height
local function get_bounding_box_dimensions(bounding_box)
	local left_top = bounding_box.left_top or bounding_box[1]
	local right_bottom = bounding_box.right_bottom or bounding_box[2]
	---@diagnostic disable-next-line: need-check-nil
	local width = (right_bottom.x or right_bottom[1]) - (left_top.x or left_top[1])
	---@diagnostic disable-next-line: need-check-nil
	local height = (right_bottom.y or right_bottom[2]) - (left_top.y or left_top[2])
	return width, height
end

---Defines the options that determine the scaling relationship of a `PrototypeScaler`.
---@class PrototypeScalerParams
---The width of the `selection_box` of the entity for which the artwork is designed.
---@field nominal_width? double
---The height of the `selection_box` of the entity for which the artwork is designed.
---@field nominal_height? double
---The desired resulting scale, relative to the baseline of 0.5. `scale` overrides the nominal size.
---@field scale? double
---The factor by which `rescale` resizes the given `subset`. `scale_factor` overrides the nominal size.
---@field scale_factor? double

---Gets the scale factor for the given `prototype` and `params`.
---@param prototype EntityPrototype
---@param params PrototypeScalerParams
---@return double
local function resolve_scalar(prototype, params)
	if params.scale_factor ~= nil then
		return params.scale_factor
	end

	if params.scale ~= nil then
		return params.scale / BASELINE_SCALE
	end

	---@cast prototype.selection_box -?
	---@cast params.nominal_width -?
	---@cast params.nominal_height -?
	local proto_width, proto_height = get_bounding_box_dimensions(prototype.selection_box)
	local width_ratio = proto_width / params.nominal_width
	local height_ratio = proto_height / params.nominal_height

	if math.abs(width_ratio - height_ratio) > ASPECT_RATIO_TOLERANCE * math.max(width_ratio, height_ratio) then
		log(
			string.format(
				"PrototypeScaler: aspect ratio mismatch for '%s' (selection box %g x %g, nominal %g x %g); fitting to selection box.",
				prototype.name or "<unnamed>",
				proto_width,
				proto_height,
				params.nominal_width,
				params.nominal_height
			)
		)
	end

	return math.min(width_ratio, height_ratio)
end

---Indicates whether a scale factor can be resolved for the given `prototype` from the given `params`.
---
---Only a scale factor that is resolved from the size of the prototype requires a `selection_box` with a positive width
---and height.
---@param prototype EntityPrototype The prototype for which the scale factor is resolved.
---@param params PrototypeScalerParams The options that determine the scaling relationship.
---@return boolean # `true` when a scale factor can be resolved; otherwise, `false`.
---@return string? # A description of the fault, when a scale factor cannot be resolved.
---@nodiscard
function PrototypeScaler.can_resolve(prototype, params)
	if params.scale or params.scale_factor then
		return true
	end

	if not (params.nominal_width and params.nominal_height) then
		return false, "cannot be scaled without a scale, a scale factor, or a nominal size"
	end

	if prototype.selection_box then
		local width, height = get_bounding_box_dimensions(prototype.selection_box)
		if width > 0 and height > 0 then
			return true
		end
	end

	return false, "has no selection box with a positive width and height"
end

local check_for_prototype = V.signature("for_prototype", {
	{ "prototype", AssetsCommon.entity_prototype },
	{
		"params",
		V.struct({
			nominal_width = Common.positive_number:optional(),
			nominal_height = Common.positive_number:optional(),
			scale = Common.positive_number:optional(),
			scale_factor = Common.positive_number:optional(),
		})
			:where(function(value)
				return value.scale == nil or value.scale_factor == nil
			end, "sets both 'scale' and 'scale_factor'")
			:where(function(value)
				return (value.nominal_width == nil) == (value.nominal_height == nil)
			end, "sets only one of 'nominal_width' and 'nominal_height'")
			:where(function(value)
				return value.scale ~= nil or value.scale_factor ~= nil or value.nominal_width ~= nil
			end, "sets no 'scale', 'scale_factor', or nominal size")
			:describe_as("a PrototypeScalerParams"),
	},
}, {
	{ parameter = "prototype", arguments = { "prototype", "params" }, check = PrototypeScaler.can_resolve },
})

---Creates a `PrototypeScaler` for the given `prototype`.
---
---#### Examples
---```lua
----- Rescale a graphics set and its flipped copy, designed for 5 x 5 tiles, for a 3 x 3 prototype.
---local PrototypeScaler = require("__reskins-assets-api__.api.prototype-scaler")
---
---local scaler = PrototypeScaler.for_prototype(prototype, { nominal_width = 5, nominal_height = 5 })
---scaler:rescale(graphics_set)
---scaler:rescale(graphics_set_flipped)
----- Both graphics sets are rescaled by a factor of 3 / 5.
---```
---@param prototype EntityPrototype The prototype for which the scaling relationship is determined.
---@param params PrototypeScalerParams The options that determine the scaling relationship.
---@return PrototypeScaler
---@throws When `prototype` is not an entity prototype.
---@throws When `params` defines a `nominal_width`, `nominal_height`, `scale`, or `scale_factor` that is not a positive number.
---@throws When `params` sets both `scale` and `scale_factor`.
---@throws When `params` sets only one of `nominal_width` and `nominal_height`.
---@throws When `params` sets no `scale`, `scale_factor`, or nominal size.
---@throws When the scale factor is resolved from the size of `prototype`, and `prototype` has no `selection_box` with a positive width and height.
---@see PrototypeScaler
---@nodiscard
function PrototypeScaler.for_prototype(prototype, params)
	check_for_prototype(prototype, params)

	return setmetatable({ scalar = resolve_scalar(prototype, params) }, PrototypeScaler)
end

local check_rescale = V.signature("rescale", {
	{ "subset", V.table():optional() },
})

---Rescales the given `subset` in place by the scale factor.
---@param subset? table The prototype or part of a prototype to rescale, such as a `graphics_set`.
---@throws When `subset` is not a table.
function PrototypeScaler:rescale(subset)
	check_rescale(subset)

	if subset and self.scalar ~= 1 then
		_sprite_utils.sprites.rescale_prototype(subset, self.scalar)
	end
end

return PrototypeScaler
