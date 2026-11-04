---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local meld = require("__core__.lualib.meld")

---Applies a `set` of type `pipe_to_ground_sprite_set` to `prototype`.
---@param prototype PipeToGroundPrototype
---@param set PipeToGroundSpriteSet
local function apply_sprite_set_to_pipe_to_ground(prototype, set)
	local set_copy = util.copy(set)
	prototype.pictures = set_copy.pictures
	prototype.frozen_patch = set_copy.frozen_patch
end

---@type PipeToGroundSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.pipe_to_ground_sprite_set,
	apply_to = apply_sprite_set_to_pipe_to_ground,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `pipe_to_ground_sprite_set`.
---@class (exact) PipeToGroundSpriteSet : EntityWithHealthSpriteSet
---The prototype's `pictures`.
---@field pictures Sprite4Way
---The prototype's `frozen_patch`.
---@field frozen_patch? Sprite4Way

---Applies the `PipeToGroundSpriteSet` to `PipeToGroundPrototype` instances.
---@class (exact) PipeToGroundSpriteSetApplicator : SpriteSetApplicator<PipeToGroundPrototype, PipeToGroundSpriteSet>
