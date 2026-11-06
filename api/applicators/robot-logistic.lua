---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local FlyingRobots = require("api.flying-robots")

---Applies a `set` of type `logistic_robot_sprite_set` to `prototype`.
---
---When the sprite set has a `corpse`, the robot falls to the ground in a death spiral when it dies, as
---`FlyingRobots.apply_death_spiral` describes.
---@param prototype LogisticRobotPrototype
---@param set LogisticRobotSpriteSet
local function apply_sprite_set_to_logistic_robot(prototype, set)
	prototype.idle = util.copy(set.idle)
	prototype.in_motion = util.copy(set.in_motion)
	prototype.shadow_idle = util.copy(set.shadow_idle)
	prototype.shadow_in_motion = util.copy(set.shadow_in_motion)

	prototype.idle_with_cargo = util.copy(set.idle_with_cargo)
	prototype.in_motion_with_cargo = util.copy(set.in_motion_with_cargo)
	prototype.shadow_idle_with_cargo = util.copy(set.shadow_idle_with_cargo)
	prototype.shadow_in_motion_with_cargo = util.copy(set.shadow_in_motion_with_cargo)

	FlyingRobots.apply_death_spiral(prototype, set)
end

---@type LogisticRobotSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.logistic_robot_sprite_set,
	apply_to = apply_sprite_set_to_logistic_robot,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `logistic_robot_sprite_set`.
---@class (exact) LogisticRobotSpriteSet : FlyingRobotSpriteSet
---The prototype's `in_motion_with_cargo`.
---@field in_motion_with_cargo? RotatedAnimation
---The prototype's `shadow_in_motion_with_cargo`.
---@field shadow_in_motion_with_cargo? RotatedAnimation
---The prototype's `idle_with_cargo`.
---@field idle_with_cargo? RotatedAnimation
---The prototype's `shadow_idle_with_cargo`.
---@field shadow_idle_with_cargo? RotatedAnimation

---Applies the `LogisticRobotSpriteSet` to `LogisticRobotPrototype` instances.
---@class (exact) LogisticRobotSpriteSetApplicator : SpriteSetApplicator<LogisticRobotPrototype, LogisticRobotSpriteSet>
