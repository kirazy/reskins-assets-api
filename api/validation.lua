---@using data
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local _defines = require("api.defines")
local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

---Provides validators for the values used by this API.
---
---#### Examples
---```lua
---local AssetsCommon = require("__reskins-assets-api__.api.validation")
---```
---@see Reskins.SpriteUtils.Validation.Common
---@class AssetsCommon
local _common = {}

---A validator that checks that a value is a symbol name.
_common.symbol = V.one_of(_defines.symbol):describe_as("a symbol name")

---A validator that checks that a value is a letter.
_common.letter = V.one_of(_defines.letter):describe_as("a letter")

---A validator that checks that a value is a light name.
_common.light = V.one_of(_defines.light):describe_as("a light name")

---A validator that checks that a value is a pipe material.
_common.pipe_material = V.one_of(_defines.pipe_material):describe_as("a pipe material")

---A validator that checks that a value is a prototype with `type` and `name` fields, and permits unknown fields.
---@type StructValidator<PrototypeBase>
_common.prototype = V.struct({
	type = Common.prototype_type_name,
	name = Common.prototype_name,
}):describe_as("a prototype")

---A validator that checks that a value is a [BoundingBox](https://lua-api.factorio.com/latest/types/BoundingBox.html),
---in either the named or the array form.
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

---A validator that checks that a value is an entity prototype with a `selection_box` that is `nil` or a `BoundingBox`.
---@type StructValidator<EntityPrototype>
_common.entity_prototype = V.struct({
	type = Common.prototype_type_name,
	name = Common.prototype_name,
	selection_box = _common.bounding_box:optional(),
}):describe_as("an entity prototype")

---A validator that checks that a value is a `SpriteSetType`.
_common.sprite_set_type = V.one_of(_defines.sprite_set_type):describe_as("a SpriteSetType")

---A validator that checks that a value is a sprite set transformer function.
---@type Validator<AnySpriteSetTransformer>
_common.sprite_set_transformer = V.func():describe_as("a sprite set transformer")

---A validator that checks that a value is a `CorpseSpriteSet` with no other fields.
---@type StructValidator<CorpseSpriteSet>
_common.corpse_sprite_set = V.struct({
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

---A validator that checks that a value is an applicator function.
---@type Validator<fun(prototype: table, set: table)>
_common.applicator_function = V.func():describe_as("an applicator function")

---A validator that checks that a value is a sprite set with nominal dimensions. Unknown fields are permitted; a
---`corpse` field is validated.
---@type StructValidator<SpriteSetBase>
_common.sprite_set = V.struct({
	nominal_width = Common.positive_number,
	nominal_height = Common.positive_number,
	corpse = _common.corpse_sprite_set:optional(),
}):describe_as("a sprite set")

---A validator that checks that a value is a `SpriteSetDefinition`.
---@type StructValidator<AnySpriteSetDefinition>
_common.sprite_set_definition = V.struct({
	set_type = _common.sprite_set_type,
	set = _common.sprite_set,
	converters = V.map(_common.sprite_set_type, _common.sprite_set_transformer):optional(),
}):describe_as("a SpriteSetDefinition")

return _common
