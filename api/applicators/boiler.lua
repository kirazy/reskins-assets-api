---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `value` of type `boiler_picture_set` to `prototype`.
---@param prototype BoilerPrototype
---@param sprite_set BoilerSpriteSet
local function apply_sprite_set_to_boiler(prototype, sprite_set)
	prototype.pictures = util.copy(sprite_set.pictures)

	Assignment.safe_assign(prototype, sprite_set, { "fire_flicker_enabled", "fire_glow_flicker_enabled" })

	-- `integration_patch`, `integration_patch_render_layer`, `water_reflection`, `drawing_box_vertical_extension`,
	-- `fluid_boxes`, `heat_buffers`, and `light_flicker` are applied by `apply_common_fields` in
	-- `api.applicator-registry`.

	-- FIXME need to handle explosion application in this step based on the package set explosion definition.
end

---@type BoilerSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.boiler_sprite_set,
	apply_to = apply_sprite_set_to_boiler,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `boiler_sprite_set`.
---@class (exact) BoilerSpriteSet : EntityWithHealthSpriteSet
---When `true`, indicates that the light intensity of the energy source controls the alpha of `fire`. When `false`, the
---alpha is always 1.
---
---When `nil`, the `fire_flicker_enabled` of the prototype is not modified.
---@field fire_flicker_enabled? boolean
---When `true`, indicates that the light intensity of the energy source controls the alpha of `fire_glow`. When `false`,
---the alpha is always 1.
---
---When `nil`, the `fire_glow_flicker_enabled` of the prototype is not modified.
---@field fire_glow_flicker_enabled? boolean
---The boiler's directional sprites.
---@field pictures BoilerPictureSet

---Applies the `BoilerSpriteSet` to `BoilerPrototype` instances.
---@class (exact) BoilerSpriteSetApplicator : SpriteSetApplicator<BoilerPrototype, BoilerSpriteSet>
