---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `inserter_sprite_set` to `prototype`.
---@param prototype InserterPrototype
---@param set InserterSpriteSet
local function apply_sprite_set_to_inserter(prototype, set)
	prototype.hand_base_picture = util.copy(set.hand_base_picture)
	prototype.hand_base_shadow = util.copy(set.hand_base_shadow)
	prototype.hand_open_picture = util.copy(set.hand_open_picture)
	prototype.hand_closed_picture = util.copy(set.hand_closed_picture)
	prototype.hand_open_shadow = util.copy(set.hand_open_shadow)
	prototype.hand_closed_shadow = util.copy(set.hand_closed_shadow)
	prototype.platform_picture = util.copy(set.platform_picture)
end

---@param explosion ExplosionPrototype
---@param set InserterSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("The applicator does not support explosions.")
end

---@type InserterSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.inserter_sprite_set,
	apply_to = apply_sprite_set_to_inserter,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `inserter_sprite_set`.
---@class (exact) InserterSpriteSet : EntityWithHealthSpriteSet
---The prototype's `hand_base_picture`.
---@field hand_base_picture Sprite
---The prototype's `hand_base_shadow`.
---@field hand_base_shadow Sprite
---The prototype's `hand_open_picture`.
---@field hand_open_picture Sprite
---The prototype's `hand_closed_picture`.
---@field hand_closed_picture Sprite
---The prototype's `hand_open_shadow`.
---@field hand_open_shadow Sprite
---The prototype's `hand_closed_shadow`.
---@field hand_closed_shadow Sprite
---The prototype's `platform_picture`.
---@field platform_picture Sprite4Way

---Applies the `InserterSpriteSet` to `InserterPrototype` instances.
---@class (exact) InserterSpriteSetApplicator : SpriteSetApplicator<InserterPrototype, InserterSpriteSet>
