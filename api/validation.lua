---@using data
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

---A catalog of ready-made validators for the values this API works with.
---
---These are ordinary validators built from `__reskins-sprite-utils__.validation`, defined once and
---shared. Builder methods never mutate, so an entry may be narrowed for a specific use without
---disturbing the shared original:
---
---```lua
---local CraftingMachineSet = AssetsCommon.sprite_set_definition:where(function(value)
---    return value.set_type == _defines.sprite_set_type.crafting_machine_sprite_set
---end, "must be a crafting machine sprite set")
---```
---
---For the Factorio structures `__reskins-sprite-utils__` already describes — icons, colors,
---vectors, file paths — see `__reskins-sprite-utils__.validation.common`.
---
---### Examples
---```lua
---local AssetsCommon = require("__reskins-assets-api__.api.validation")
---
---local check_get_symbol = V.signature("get_symbol", {
---    { "symbol", AssetsCommon.symbol },
---    { "tint", Common.color },
---})
---```
---@class AssetsCommon
local _common = {}

-- Icon vocabulary

---A symbol an icon may be drawn for.
_common.symbol = V.one_of(_defines.symbol--[[@as (string[])]]):describe_as("a symbol name")

---A letter an icon may be drawn for.
_common.letter = V.one_of(_defines.letter--[[@as (string[])]]):describe_as("a letter")

---A material a pipe may be built from.
_common.pipe_material = V.one_of(_defines.pipe_material--[[@as (string[])]]):describe_as("a pipe material")

-- Prototypes

---A prototype, carrying the `type` and `name` every prototype has.
---
---Left open to unrecognized fields, since a prototype carries far more than this.
---@type ShapeValidator<PrototypeBase>
_common.prototype = V.shape({
	type = Common.prototype_type_name,
	name = Common.prototype_name,
}):describe_as("a prototype")

---A [BoundingBox](https://lua-api.factorio.com/latest/types/BoundingBox.html), in either the named
---(`left_top` and `right_bottom`) or the array form.
---@type Validator<BoundingBox>
_common.bounding_box = V.table()
	:satisfies(function(value)
		local left_top = value.left_top or value[1]
		local right_bottom = value.right_bottom or value[2]

		if type(left_top) ~= "table" or type(right_bottom) ~= "table" then
			return false
		end

		for _, corner in pairs({ left_top, right_bottom }) do
			if type(corner.x or corner[1]) ~= "number" or type(corner.y or corner[2]) ~= "number" then
				return false
			end
		end

		return true
	end, "a BoundingBox with an x and y coordinate for each of its two corners")
	:describe_as("a BoundingBox")

---An entity prototype, carrying the `selection_box` automatic scaling is measured against.
---@type ShapeValidator<EntityPrototype>
_common.entity_prototype = V.shape({
	type = Common.prototype_type_name,
	name = Common.prototype_name,
	selection_box = _common.bounding_box:optional(),
}):describe_as("an entity prototype")

-- Sprite sets

---The shape a sprite set takes.
_common.sprite_set_type = V.one_of(_defines.sprite_set_type--[[@as (string[])]]):describe_as("a SpriteSetType")

---A transformer converting a sprite set from one `SpriteSetType` to another.
---@type Validator<AnySpriteSetTransformer>
_common.sprite_set_transformer = V.custom(function(value)
	return type(value) == "function"
end, "a function taking a sprite set and returning a sprite set"):describe_as("a sprite set transformer")

---The remnant art applied to a corpse prototype: rescaled along with the rest of the sprite set,
---then copied onto the prototype field by field.
---
---Closed to unrecognized fields, because that copy is unconditional and follows the rescaling. A
---field a `CorpsePrototype` genuinely has but the art does not — `collision_box`, `selection_box`,
---`tile_width`, `tile_height` — is resized on the way through and then written over the prototype's
---own, corrupting it rather than being ignored. A misspelling is reported here instead of reaching
---the game as a log warning.
---@type ShapeValidator<CorpseSpriteSet>
_common.corpse_sprite_set = V.shape({
	animation = V.any():optional(),
	animation_overlay = V.any():optional(),
	animation_overlay_render_layer = V.any():optional(),
	animation_render_layer = V.any():optional(),
	decay_animation = V.any():optional(),
	decay_frame_transition_duration = V.any():optional(),
	direction_shuffle = V.any():optional(),
	dying_speed = V.any():optional(),
	final_render_layer = V.any():optional(),
	ground_patch = V.any():optional(),
	ground_patch_decay = V.any():optional(),
	ground_patch_fade_in_delay = V.any():optional(),
	ground_patch_fade_in_speed = V.any():optional(),
	ground_patch_fade_out_duration = V.any():optional(),
	ground_patch_fade_out_start = V.any():optional(),
	ground_patch_higher = V.any():optional(),
	ground_patch_render_layer = V.any():optional(),
	shuffle_directions_at_frame = V.any():optional(),
	splash = V.any():optional(),
	splash_render_layer = V.any():optional(),
	splash_speed = V.any():optional(),
	underwater_layer_offset = V.any():optional(),
	underwater_patch = V.any():optional(),
})
	:strict()
	:describe_as("a CorpseSpriteSet")

---The function an applicator paints a prototype with.
---@type Validator<fun(prototype: table, set: table)>
_common.applicator_function = V.custom(function(value)
	return type(value) == "function"
end, "a function taking a prototype and a sprite set"):describe_as("an applicator function")

---The sprite data itself, carrying the nominal dimensions scaling is resolved from.
---
---Left open to unrecognized fields, since the fields beyond these vary by `SpriteSetType`. The
---`corpse` it may carry is checked, being copied onto a prototype rather than read field by field.
---@type ShapeValidator<SpriteSetBase>
_common.sprite_set = V.shape({
	nominal_width = Common.positive_number,
	nominal_height = Common.positive_number,
	corpse = _common.corpse_sprite_set:optional(),
}):describe_as("a sprite set")

---A sprite set tagged with its `SpriteSetType`.
---@type ShapeValidator<AnySpriteSetDefinition>
_common.sprite_set_definition = V.shape({
	set_type = _common.sprite_set_type,
	set = _common.sprite_set,
	converters = V.map(_common.sprite_set_type, _common.sprite_set_transformer):optional(),
}):describe_as("a SpriteSetDefinition")

return _common
