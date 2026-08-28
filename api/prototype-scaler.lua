---@using data

---@namespace Reskins.Assets

local _sprite_utils = { sprites = require("__reskins-sprite-utils__.sprites") }
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")
local AssetsCommon = require("api.validation")

---The sprite scale graphics in this asset collection are authored at. An explicit `scale` is
---expressed relative to this value, so a `scale` equal to the baseline resolves to a factor of `1`
---(no change).
local BASELINE_SCALE = 0.5

---Resolves a single uniform scale factor for a prototype, then applies that factor to arbitrary
---sprite-bearing subsets on demand.
---
---The factor is resolved once, at construction, from one of three sources (in order of precedence):
---1. An explicit `scale_factor` multiplier.
---2. An explicit `scale`, the desired resulting scale
---   relative to the baseline of `0.5`.
---3. Automatic resolution by comparing the prototype's `selection_box` to its nominal dimensions.
---
---`rescale` may then be called any number of times to scale
---individual subsets in place.
---
---### Examples
---```lua
---local PrototypeScaler = require("__reskins-assets-api__.api.prototype-scaler")
---
---local scaler = PrototypeScaler.for_prototype(prototype, { nominal_width = 5, nominal_height = 5 })
---scaler:rescale(graphics_set)
---scaler:rescale(graphics_set_flipped)
---```
---@class PrototypeScaler
---@field private scalar double? The uniform scale factor, or `nil` when no scaling applies.
local PrototypeScaler = {}
PrototypeScaler.__index = PrototypeScaler

---Extracts the width and height of a bounding box, tolerating both the named
---(`left_top` / `right_bottom`) and array (`[1]` / `[2]`) forms.
---@param bounding_box BoundingBox
---@return double width, double height
local function get_bounding_box_dimensions(bounding_box)
	local left_top = bounding_box.left_top or bounding_box[1]
	local right_bottom = bounding_box.right_bottom or bounding_box[2]
	---@diagnostic disable-next-line: need-check-nil
	local width = (right_bottom.x or right_bottom[1]) - (left_top.x or left_top[1])
	---@diagnostic disable-next-line: need-check-nil
	local height = (right_bottom.y or right_bottom[2]) - (left_top.y or left_top[2])
	return width, height
end

---@class PrototypeScalerParams
---@field nominal_width double? The width, in tiles, the graphics were authored at. Drives automatic scaling.
---@field nominal_height double? The height, in tiles, the graphics were authored at. Drives automatic scaling.
---@field scale double? The desired resulting scale, relative to the baseline of `0.5`. Overrides automatic scaling.
---@field scale_factor double? An explicit multiplier to apply. Overrides both `scale` and automatic scaling.

---Resolves the scale factor implied by an explicit `scale` / `scale_factor`, or by comparing the
---prototype's `selection_box` to its nominal dimensions. Returns `nil` (identity) when no source applies.
---@param prototype EntityPrototype
---@param params PrototypeScalerParams
---@return double?
local function resolve_scalar(prototype, params)
	if params.scale_factor ~= nil then
		if params.scale ~= nil then
			log(
				string.format(
					"PrototypeScaler: both 'scale' and 'scale_factor' provided for '%s'; using 'scale_factor'.",
					prototype.name or "<unnamed>"
				)
			)
		end
		return params.scale_factor
	end

	if params.scale ~= nil then
		return params.scale / BASELINE_SCALE
	end

	if params.nominal_width and params.nominal_height and prototype.selection_box then
		local proto_width, proto_height = get_bounding_box_dimensions(prototype.selection_box)

		-- Cross-multiply to compare aspect ratios without division.
		if math.abs(params.nominal_width * proto_height - proto_width * params.nominal_height) < 1e-9 then
			return proto_width / params.nominal_width
		end

		log(
			string.format(
				"PrototypeScaler: aspect ratio mismatch for '%s' (selection box %g x %g, nominal %g x %g); skipping scaling.",
				prototype.name or "<unnamed>",
				proto_width,
				proto_height,
				params.nominal_width,
				params.nominal_height
			)
		)
	end

	return nil
end

local check_for_prototype = V.signature("for_prototype", {
	{ "prototype", AssetsCommon.entity_prototype },
	{
		"params",
		V.shape({
			nominal_width = Common.positive_number:optional(),
			nominal_height = Common.positive_number:optional(),
			scale = Common.positive_number:optional(),
			scale_factor = Common.positive_number:optional(),
		})
			:describe_as("a PrototypeScalerParams")
			:optional(),
	},
})

---Creates a `PrototypeScaler` for the given `prototype`.
---
---The scale factor is resolved from `params` (see `PrototypeScalerParams`
---for precedence). The resulting scaler is an identity (a no-op) when no source applies — i.e. no explicit
---`scale` / `scale_factor`, and either the nominal dimensions are unset, the prototype has no `selection_box`,
---or its aspect ratio does not match the nominal aspect ratio (in which case a warning is logged).
---@param prototype EntityPrototype The prototype to derive scaling from.
---@param params PrototypeScalerParams? The scaling configuration. Defaults to automatic resolution.
---@return PrototypeScaler
---
---### Exceptions
---*@throws* `string` — Thrown when `prototype` is not an entity prototype.\
---*@throws* `string` — Thrown when `params` carries a `nominal_width`, `nominal_height`, `scale`, or `scale_factor` that is not a positive number.
---@nodiscard
function PrototypeScaler.for_prototype(prototype, params)
	check_for_prototype(prototype, params)

	return setmetatable({ scalar = resolve_scalar(prototype, params or {}) }, PrototypeScaler)
end

local check_rescale = V.signature("rescale", {
	{ "subset", V.table():optional() },
})

---Rescales the given sprite-bearing `subset` in place.
---
---Does nothing when the scaler is an identity (no applicable scale factor, or a factor of 1), or
---when `subset` is `nil` — so callers may invoke this unconditionally on optional subsets.
---@param subset table? A sprite-bearing table to rescale in place.
---
---### Exceptions
---*@throws* `string` — Thrown when `subset` is not a table.
function PrototypeScaler:rescale(subset)
	check_rescale(subset)

	if subset and self.scalar and self.scalar ~= 1 then
		_sprite_utils.sprites.rescale_prototype(subset, self.scalar)
	end
end

return PrototypeScaler
