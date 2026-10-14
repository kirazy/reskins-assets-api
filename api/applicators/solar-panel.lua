---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `solar_panel_sprite_set` to `prototype`.
---@param prototype SolarPanelPrototype
---@param set SolarPanelSpriteSet
local function apply_sprite_set_to_solar_panel(prototype, set)
	prototype.picture = util.copy(set.picture)
	prototype.overlay = util.copy(set.overlay)
end

---@param explosion ExplosionPrototype
---@param set SolarPanelSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("The applicator does not support explosions.")
end

---@type SolarPanelSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.solar_panel_sprite_set,
	apply_to = apply_sprite_set_to_solar_panel,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `solar_panel_sprite_set`.
---@class (exact) SolarPanelSpriteSet : EntityWithHealthSpriteSet
---The prototype's `picture`.
---@field picture? SpriteVariations
---The prototype's `overlay`.
---@field overlay? SpriteVariations

---Applies the `SolarPanelSpriteSet` to `SolarPanelPrototype` instances.
---@class (exact) SolarPanelSpriteSetApplicator : SpriteSetApplicator<SolarPanelPrototype, SolarPanelSpriteSet>
