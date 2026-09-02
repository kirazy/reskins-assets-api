---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `storage_tank_sprite_set`-shaped `set` to `prototype`.
---@param prototype StorageTankPrototype
---@param set StorageTankSpriteSet
local function apply_sprite_set_to_storage_tank(prototype, set)
	prototype.pictures = util.copy(set.pictures)
end

---@param explosion ExplosionPrototype
---@param set StorageTankSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type StorageTankSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.storage_tank_sprite_set,
	apply_to = apply_sprite_set_to_storage_tank,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data of a `SpriteSetDefinition` of type `storage_tank_sprite_set`.
---@class (exact) StorageTankSpriteSet : EntityWithHealthSpriteSet
---The prototype's `pictures`.
---@field pictures StorageTankPictures

---The applicator for storage tanks.
---@class (exact) StorageTankSpriteSetApplicator : SpriteSetApplicator<StorageTankPrototype, StorageTankSpriteSet>
