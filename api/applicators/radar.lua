---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `radar_sprite_set` to `prototype`.
---@param prototype RadarPrototype
---@param set RadarSpriteSet
local function apply_sprite_set_to_radar(prototype, set)
	prototype.pictures = util.copy(set.pictures)
	prototype.frozen_patch = feature_flags["freezing"] and util.copy(set.frozen_patch) or nil
	prototype.reset_orientation_when_frozen = set.reset_orientation_when_frozen

	Assignment.safe_assign(prototype, set, { "circuit_connector" })
end

---@type RadarSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.radar_sprite_set,
	apply_to = apply_sprite_set_to_radar,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `radar_sprite_set`.
---@class (exact) RadarSpriteSet : EntityWithHealthSpriteSet
---The prototype's `pictures`.
---@field pictures RotatedSprite
---The prototype's `frozen_patch`. The game loads it as a rotated sprite with one direction.
---@field frozen_patch? RotatedSprite
---When `true`, indicates that the radar resets its orientation when it is frozen. Default `false`.
---@field reset_orientation_when_frozen? boolean
---When `nil`, the circuit connector of the prototype is not modified.
---@field circuit_connector? CircuitConnectorDefinition

---Applies the `RadarSpriteSet` to `RadarPrototype` instances.
---@class (exact) RadarSpriteSetApplicator : SpriteSetApplicator<RadarPrototype, RadarSpriteSet>
