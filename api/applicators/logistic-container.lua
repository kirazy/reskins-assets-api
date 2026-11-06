---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `logistic_container_sprite_set` to `prototype`.
---@param prototype LogisticContainerPrototype
---@param set LogisticContainerSpriteSet
local function apply_sprite_set_to_logistic_container(prototype, set)
	prototype.picture = util.copy(set.picture)

	local robot_door = util.copy(prototype.robot_door) or {}
	robot_door.animation = util.copy(set.robot_door.animation)
	prototype.robot_door = robot_door

	Assignment.safe_assign(prototype, set, { "circuit_connector" })
end

---@type LogisticContainerSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.logistic_container_sprite_set,
	apply_to = apply_sprite_set_to_logistic_container,
}

---Defines the robot door graphics of a logistic container.
---@class (exact) RobotDoorGraphics
---Drawn when a robot brings/takes items from this entity.
---
---When `nil`, the robot door animation of the prototype is removed.
---
---See [RobotDoorSpecification::animation](https://lua-api.factorio.com/latest/types/RobotDoorSpecification.html#animation).
---@field animation? Animation

---Defines the sprite data in a `SpriteSetDefinition` of type `logistic_container_sprite_set`.
---@class (exact) LogisticContainerSpriteSet : ContainerSpriteSet
---The fields of `prototype.robot_door` that `RobotDoorGraphics` does not define are not modified.
---@field robot_door RobotDoorGraphics

---Applies the `LogisticContainerSpriteSet` to `LogisticContainerPrototype` instances.
---@class (exact) LogisticContainerSpriteSetApplicator : SpriteSetApplicator<LogisticContainerPrototype, LogisticContainerSpriteSet>
