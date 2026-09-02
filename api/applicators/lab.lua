---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `lab_sprite_set`-shaped `set` to `prototype`.
---@param prototype LabPrototype
---@param set LabSpriteSet
local function apply_sprite_set_to_lab(prototype, set)
	prototype.frozen_patch = feature_flags["freezing"] and util.copy(set.frozen_patch) or nil
	prototype.on_animation = util.copy(set.on_animation)
	prototype.off_animation = util.copy(set.off_animation)
end

---@param explosion ExplosionPrototype
---@param set LabSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type LabSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.lab_sprite_set,
	apply_to = apply_sprite_set_to_lab,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data of a `SpriteSetDefinition` of type `lab_sprite_set`.
---@class (exact) LabSpriteSet : EntityWithHealthSpriteSet
---@field frozen_patch Sprite?
---@field on_animation Animation?
---@field off_animation Animation?

---The applicator for labs.
---@class (exact) LabSpriteSetApplicator : SpriteSetApplicator<LabPrototype, LabSpriteSet>
