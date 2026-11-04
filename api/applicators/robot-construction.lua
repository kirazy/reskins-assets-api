---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local FlyingRobots = require("api.flying-robots")

---Applies a `set` of type `construction_robot_sprite_set` to `prototype`.
---
---When the sprite set has a `corpse`, the robot falls to the ground in a death spiral when it dies, as
---`FlyingRobots.apply_death_spiral` describes.
---@param prototype ConstructionRobotPrototype
---@param set ConstructionRobotSpriteSet
local function apply_sprite_set_to_construction_robot(prototype, set)
	prototype.idle = util.copy(set.idle)
	prototype.in_motion = util.copy(set.in_motion)
	prototype.shadow_idle = util.copy(set.shadow_idle)
	prototype.shadow_in_motion = util.copy(set.shadow_in_motion)

	prototype.working = util.copy(set.working)
	prototype.shadow_working = util.copy(set.shadow_working)

	FlyingRobots.apply_death_spiral(prototype, set)
end

---@type ConstructionRobotSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.construction_robot_sprite_set,
	apply_to = apply_sprite_set_to_construction_robot,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `construction_robot_sprite_set`.
---@class (exact) ConstructionRobotSpriteSet : FlyingRobotSpriteSet
---The prototype's `working`.
---@field working RotatedAnimation
---The prototype's `shadow_working`.
---@field shadow_working RotatedAnimation

---Applies the `ConstructionRobotSpriteSet` to `ConstructionRobotPrototype` instances.
---@class (exact) ConstructionRobotSpriteSetApplicator : SpriteSetApplicator<ConstructionRobotPrototype, ConstructionRobotSpriteSet>
