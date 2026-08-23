---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Defines

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `construction_robot_sprite_set`-shaped `set` to `prototype`.
---@param prototype ConstructionRobotPrototype
---@param set ConstructionRobotSpriteSet
local function apply_sprite_set_to_construction_robot(prototype, set)
	prototype.idle = util.copy(set.idle)
	prototype.in_motion = util.copy(set.in_motion)
	prototype.shadow_idle = util.copy(set.shadow_idle)
	prototype.shadow_in_motion = util.copy(set.shadow_in_motion)

	prototype.working = util.copy(set.working)
	prototype.shadow_working = util.copy(set.shadow_working)
end

---@param explosion ExplosionPrototype
---@param set ConstructionRobotSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type ConstructionRobotSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.construction_robot_sprite_set,
	apply_to = apply_sprite_set_to_construction_robot,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data a `construction_robot_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) ConstructionRobotSpriteSet : FlyingRobotSpriteSet
---The prototype's `working`.
---@field working RotatedAnimation
---The prototype's `shadow_working`.
---@field shadow_working RotatedAnimation

---The applicator for construction robots.
---@class (exact) ConstructionRobotSpriteSetApplicator : SpriteSetApplicator<ConstructionRobotPrototype, ConstructionRobotSpriteSet>
