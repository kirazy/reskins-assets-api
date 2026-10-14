---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `value` of type `boiler_picture_set` to `prototype`.
---@param prototype BoilerPrototype
---@param sprite_set BoilerSpriteSet
local function apply_sprite_set_to_boiler(prototype, sprite_set)
	prototype.pictures = util.copy(sprite_set.pictures)

	-- FIXME: Need to handle application of fluid boxes to the `fluid_box`, `output_fluid_box` and
	-- fluid energy source `fluid_box`.

	-- `integration_patch`, `integration_patch_render_layer`, and `water_reflection` are applied by
	-- `apply_common_fields` in `api.applicator-registry`.

	-- FIXME need to handle explosion application in this step based on the package set explosion definition.
end

---@param explosion ExplosionPrototype
---@param sprite_set BoilerSpriteSet
local function apply_sprite_set_to_explosion(explosion, sprite_set)
	error("The applicator does not support explosions.")
end

---@type BoilerSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.boiler_sprite_set,
	apply_to = apply_sprite_set_to_boiler,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `boiler_sprite_set`.
---@class (exact) BoilerSpriteSet : EntityWithHealthSpriteSet
---When `true`, indicates that the light intensity of the energy source controls the alpha of `fire`. When `false`, the
---alpha is always 1.
---@field fire_flicker_enabled? boolean
---When `true`, indicates that the light intensity of the energy source controls the alpha of `fire_glow`. When `false`,
---the alpha is always 1.
---@field fire_glow_flicker_enabled? boolean
---Fluid box pipe graphics, matched to the prototype's fluid boxes by direction.
---@field fluid_boxes? FluidBoxGraphics[]
---The boiler's directional sprites.
---@field pictures BoilerPictureSet

---Applies the `BoilerSpriteSet` to `BoilerPrototype` instances.
---@class (exact) BoilerSpriteSetApplicator : SpriteSetApplicator<BoilerPrototype, BoilerSpriteSet>
