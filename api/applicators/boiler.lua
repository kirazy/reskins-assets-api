---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Defines

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `boiler_picture_set`-shaped `value` to `prototype`.
---@param prototype BoilerPrototype
---@param sprite_set BoilerSpriteSet
local function apply_sprite_set_to_boiler(prototype, sprite_set)
	prototype.pictures = util.copy(sprite_set.pictures)

	-- FIXME: Need to handle application of fluid boxes to the `fluid_box`, `output_fluid_box` and
	-- fluid energy source `fluid_box`.

	-- `integration_patch`/`integration_patch_render_layer`/`water_reflection` are applied centrally
	-- by `api.apply`'s `apply_common_fields`, not here — see that function's doc comment.

	-- FIXME need to handle explosion application in this step based on the package set explosion definition.
end

---@param explosion ExplosionPrototype
---@param sprite_set BoilerSpriteSet
local function apply_sprite_set_to_explosion(explosion, sprite_set)
	error("Not implemented")
end

---@type BoilerSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.boiler_sprite_set,
	apply_to = apply_sprite_set_to_boiler,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data a `boiler_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) BoilerSpriteSet : EntityWithHealthSpriteSet
---If this is set to false, `fire` alpha is always 1 instead of being controlled by the light intensity of the energy source.
---@field fire_flicker_enabled? boolean
---If this is set to false, `fire_glow` alpha is always 1 instead of being controlled by the light intensity of the energy source.
---@field fire_glow_flicker_enabled? boolean
---Fluid box pipe graphics, matched to the prototype's fluid boxes by direction.
---@field fluid_boxes FluidBoxGraphics[]?
---The boiler's directional sprites.
---@field pictures BoilerPictureSet

---The applicator for boilers.
---@class (exact) BoilerSpriteSetApplicator : SpriteSetApplicator<BoilerPrototype, BoilerSpriteSet>
