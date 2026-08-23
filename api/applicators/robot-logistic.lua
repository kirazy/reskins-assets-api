---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Defines

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `logistic_robot_sprite_set`-shaped `set` to `prototype`.
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
end

---@param explosion ExplosionPrototype
---@param set LogisticRobotSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type LogisticRobotSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.logistic_robot_sprite_set,
	apply_to = apply_sprite_set_to_logistic_robot,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data a `logistic_robot_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) LogisticRobotSpriteSet : FlyingRobotSpriteSet
---The prototype's `in_motion_with_cargo`.
---@field in_motion_with_cargo RotatedAnimation?
---The prototype's `shadow_in_motion_with_cargo`.
---@field shadow_in_motion_with_cargo RotatedAnimation?
---The prototype's `idle_with_cargo`.
---@field idle_with_cargo RotatedAnimation?
---The prototype's `shadow_idle_with_cargo`.
---@field shadow_idle_with_cargo RotatedAnimation?

---The applicator for logistic robots.
---@class (exact) LogisticRobotSpriteSetApplicator : SpriteSetApplicator<LogisticRobotPrototype, LogisticRobotSpriteSet>
