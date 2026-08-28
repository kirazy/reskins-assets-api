---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `solar_panel_sprite_set`-shaped `set` to `prototype`.
---@param prototype SolarPanelPrototype
---@param set SolarPanelSpriteSet
local function apply_sprite_set_to_solar_panel(prototype, set)
	prototype.picture = util.copy(set.picture)
	prototype.overlay = util.copy(set.overlay)
end

---@param explosion ExplosionPrototype
---@param set SolarPanelSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type SolarPanelSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.solar_panel_sprite_set,
	apply_to = apply_sprite_set_to_solar_panel,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data a `solar_panel_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) SolarPanelSpriteSet : EntityWithHealthSpriteSet
---The prototype's `picture`.
---@field picture SpriteVariations?
---The prototype's `overlay`.
---@field overlay SpriteVariations?

---The applicator for solar panels.
---@class (exact) SolarPanelSpriteSetApplicator : SpriteSetApplicator<SolarPanelPrototype, SolarPanelSpriteSet>
