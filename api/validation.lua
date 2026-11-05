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

---A validator that checks that a value is a technology constant.
_common.technology_constant = V.one_of(_defines.technology_constant):describe_as("a technology constant")

---A validator that checks that a value is an equipment overlay.
_common.equipment_overlay = V.one_of(_defines.equipment_overlay):describe_as("an equipment overlay")

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
_common.corpse_sprite_set = V.class("CorpseSpriteSet", {
	animation = V.any():optional(),
	animation_overlay = V.any():optional(),
	animation_overlay_final_render_layer = V.any():optional(),
	animation_overlay_render_layer = V.any():optional(),
	animation_render_layer = V.any():optional(),
	collision_box = V.any():optional(),
	decay_animation = V.any():optional(),
	decay_frame_transition_duration = V.any():optional(),
	direction_shuffle = V.any():optional(),
	dying_speed = V.any():optional(),
	expires = V.any():optional(),
	final_render_layer = V.any():optional(),
	flags = V.any():optional(),
	ground_patch = V.any():optional(),
	ground_patch_decay = V.any():optional(),
	ground_patch_fade_in_delay = V.any():optional(),
	ground_patch_fade_in_speed = V.any():optional(),
	ground_patch_fade_out_duration = V.any():optional(),
	ground_patch_fade_out_start = V.any():optional(),
	ground_patch_higher = V.any():optional(),
	ground_patch_render_layer = V.any():optional(),
	hidden_in_factoriopedia = V.any():optional(),
	order = V.any():optional(),
	remove_on_entity_placement = V.any():optional(),
	remove_on_tile_placement = V.any():optional(),
	selectable_in_game = V.any():optional(),
	shuffle_directions_at_frame = V.any():optional(),
	splash = V.any():optional(),
	splash_render_layer = V.any():optional(),
	splash_speed = V.any():optional(),
	subgroup = V.any():optional(),
	time_before_removed = V.any():optional(),
	time_before_shading_off = V.any():optional(),
	underwater_layer_offset = V.any():optional(),
	underwater_patch = V.any():optional(),
})
	:strict()
	:describe_as("a CorpseSpriteSet")

---A validator that checks that a value is a `ParticleSpriteSet` with no other fields.
_common.particle_sprite_set = V.class("ParticleSpriteSet", {
	draw_shadow_when_on_ground = V.any():optional(),
	ended_in_water_trigger_effect = V.any():optional(),
	ended_on_ground_trigger_effect = V.any():optional(),
	fade_away_duration = V.any():optional(),
	life_time = V.any():optional(),
	mining_particle_frame_speed = V.any():optional(),
	movement_modifier = V.any():optional(),
	movement_modifier_when_on_ground = V.any():optional(),
	pictures = V.any():optional(),
	regular_trigger_effect = V.any():optional(),
	regular_trigger_effect_frequency = V.any():optional(),
	render_layer = V.any():optional(),
	render_layer_when_on_ground = V.any():optional(),
	shadows = V.any():optional(),
	vertical_acceleration = V.any():optional(),
})
	:strict()
	:describe_as("a ParticleSpriteSet")

---A validator that checks that a value is an `ExplosionSpriteSet` with no other fields.
---@type Validator<ExplosionSpriteSet>
_common.explosion_sprite_set = V.class("ExplosionSpriteSet", {
	animations = V.any():optional(),
	beam = V.any():optional(),
	correct_rotation = V.any():optional(),
	delay = V.any():optional(),
	delay_deviation = V.any():optional(),
	explosion_effect = V.any():optional(),
	fade_in_duration = V.any():optional(),
	fade_out_duration = V.any():optional(),
	height = V.any():optional(),
	light = V.any():optional(),
	light_intensity_factor_final = V.any():optional(),
	light_intensity_factor_initial = V.any():optional(),
	light_intensity_peak_end_progress = V.any():optional(),
	light_intensity_peak_start_progress = V.any():optional(),
	light_size_factor_final = V.any():optional(),
	light_size_factor_initial = V.any():optional(),
	light_size_peak_end_progress = V.any():optional(),
	light_size_peak_start_progress = V.any():optional(),
	render_layer = V.any():optional(),
	rotate = V.any():optional(),
	scale = V.any():optional(),
	scale_animation_speed = V.any():optional(),
	scale_deviation = V.any():optional(),
	scale_end = V.any():optional(),
	scale_in_duration = V.any():optional(),
	scale_increment_per_tick = V.any():optional(),
	scale_initial = V.any():optional(),
	scale_initial_deviation = V.any():optional(),
	scale_out_duration = V.any():optional(),
	smoke = V.any():optional(),
	smoke_count = V.any():optional(),
	smoke_slow_down_factor = V.any():optional(),
	sound = V.any():optional(),
	created_effect = V.any():optional(),
	flags = V.any():optional(),
	hidden = V.any():optional(),
	subgroup = V.any():optional(),
	order = V.any():optional(),
	particles = V.map(Common.prototype_name, _common.particle_sprite_set):optional(),
	explosions = V.map(
		Common.prototype_name,
		V.lazy(function()
			return _common.explosion_sprite_set
		end)
	):optional(),
})
	:strict()
	:describe_as("an ExplosionSpriteSet")

---A validator that checks that a value is the `corpse` of a sprite set: a `CorpseSpriteSet`, the name of a corpse, or
---`_defines.generic_remnants`.
_common.corpse = V.any_of(_common.corpse_sprite_set, V.literal(_defines.generic_remnants), Common.prototype_name)
	:describe_as("a CorpseSpriteSet, a corpse name, or 'generic-remnants'")

---A validator that checks that a value is the `dying_explosion` of a sprite set: an `ExplosionSpriteSet` or the name of
---an explosion.
_common.dying_explosion = V.any_of(_common.explosion_sprite_set, Common.prototype_name)
	:describe_as("an ExplosionSpriteSet or an explosion name")

---A validator that checks that a value is an applicator function.
---@type Validator<fun(prototype: table, set: table)>
_common.applicator_function = V.func():describe_as("an applicator function")

---A validator that checks that a value is a `FluidBoxGraphics` with no unrecognized fields.
_common.fluid_box_graphics = V.class("FluidBoxGraphics", {
	pipe_connections = V.array(V.table()):optional(),
	render_layer = V.any():optional(),
	draw_only_when_connected = V.any():optional(),
	always_draw_covers = V.any():optional(),
	pipe_covers = V.any():optional(),
	pipe_covers_frozen = V.any():optional(),
	pipe_picture = V.any():optional(),
	pipe_picture_frozen = V.any():optional(),
	mirrored_pipe_picture = V.any():optional(),
	mirrored_pipe_picture_frozen = V.any():optional(),
	secondary_draw_order = V.any():optional(),
	secondary_draw_orders = V.any():optional(),
	enable_working_visualisations = V.any():optional(),
})
	:strict()
	:describe_as("a FluidBoxGraphics")

---A validator that checks that a value is a `HeatBufferGraphics` with no unrecognized fields.
_common.heat_buffer_graphics = V.class("HeatBufferGraphics", {
	connections = V.array(V.table()):optional(),
	pipe_covers = V.any():optional(),
	heat_pipe_covers = V.any():optional(),
	heat_picture = V.any():optional(),
	heat_glow = V.any():optional(),
})
	:strict()
	:describe_as("a HeatBufferGraphics")

---A validator that checks that a value is a sprite set with nominal dimensions. Unknown fields are permitted; a
---`corpse` field, a `dying_explosion` field, a `fluid_boxes` field, a `heat_buffers` field, and a `pipe_material` field
---are validated.
---@type StructValidator<SpriteSetBase>
_common.sprite_set = V.struct({
	nominal_width = Common.positive_number,
	nominal_height = Common.positive_number,
	corpse = _common.corpse:optional(),
	dying_explosion = _common.dying_explosion:optional(),
	fluid_boxes = V.array(_common.fluid_box_graphics):optional(),
	heat_buffers = V.array(_common.heat_buffer_graphics):optional(),
	pipe_material = _common.pipe_material:optional(),
}):describe_as("a sprite set")

---A validator that checks that a value is a `SpriteSetDefinition`.
---@type StructValidator<AnySpriteSetDefinition>
_common.sprite_set_definition = V.struct({
	set_type = _common.sprite_set_type,
	set = _common.sprite_set,
	converters = V.map(_common.sprite_set_type, _common.sprite_set_transformer):optional(),
}):describe_as("a SpriteSetDefinition")

return _common
