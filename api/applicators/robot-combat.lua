---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local FlyingRobots = require("api.flying-robots")

---Applies a `set` of type `combat_robot_sprite_set` to `prototype`.
---
---When the sprite set has a `corpse`, the robot falls to the ground in a death spiral when it dies, as
---`FlyingRobots.apply_death_spiral` describes.
---@param prototype CombatRobotPrototype
---@param set CombatRobotSpriteSet
local function apply_sprite_set_to_combat_robot(prototype, set)
	prototype.idle = util.copy(set.idle)
	prototype.in_motion = util.copy(set.in_motion)
	prototype.shadow_idle = util.copy(set.shadow_idle)
	prototype.shadow_in_motion = util.copy(set.shadow_in_motion)

	prototype.light = util.copy(set.light)

	FlyingRobots.apply_death_spiral(prototype, set)
end

---@type CombatRobotSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.combat_robot_sprite_set,
	apply_to = apply_sprite_set_to_combat_robot,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `combat_robot_sprite_set`.
---@class (exact) CombatRobotSpriteSet : FlyingRobotSpriteSet
---When `nil`, the robot has no light.
---@field light? LightDefinition

---Applies the `CombatRobotSpriteSet` to `CombatRobotPrototype` instances.
---@class (exact) CombatRobotSpriteSetApplicator : SpriteSetApplicator<CombatRobotPrototype, CombatRobotSpriteSet>
