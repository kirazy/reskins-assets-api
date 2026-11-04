---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `combat_robot_sprite_set` to `prototype`.
---@param prototype CombatRobotPrototype
---@param set CombatRobotSpriteSet
local function apply_sprite_set_to_combat_robot(prototype, set)
	prototype.idle = util.copy(set.idle)
	prototype.in_motion = util.copy(set.in_motion)
	prototype.shadow_idle = util.copy(set.shadow_idle)
	prototype.shadow_in_motion = util.copy(set.shadow_in_motion)

	prototype.light = util.copy(set.light)
end

---@type CombatRobotSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.combat_robot_sprite_set,
	apply_to = apply_sprite_set_to_combat_robot,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `combat_robot_sprite_set`.
---@class (exact) CombatRobotSpriteSet : FlyingRobotSpriteSet
---When `nil`, the robot has no light.
---@field light? LightDefinition

---Applies the `CombatRobotSpriteSet` to `CombatRobotPrototype` instances.
---@class (exact) CombatRobotSpriteSetApplicator : SpriteSetApplicator<CombatRobotPrototype, CombatRobotSpriteSet>
