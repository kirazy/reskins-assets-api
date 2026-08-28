---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `roboport_sprite_set`-shaped `set` to `prototype`.
---@param prototype RoboportPrototype
---@param set RoboportSpriteSet
local function apply_sprite_set_to_roboport(prototype, set)
	local graphics_set = util.copy(set.graphics_set)

	prototype.base = graphics_set.base
	prototype.base_patch = graphics_set.base_patch
	prototype.base_animation = graphics_set.base_animation
	prototype.door_animation_up = graphics_set.door_animation_up
	prototype.door_animation_down = graphics_set.door_animation_down
	prototype.recharging_animation = graphics_set.recharging_animation
end

---@param explosion ExplosionPrototype
---@param set RoboportSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type RoboportSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.roboport_sprite_set,
	apply_to = apply_sprite_set_to_roboport,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---@class (exact) RoboportGraphicsSet
---@field base Sprite
---@field base_patch Sprite
---@field base_animation Animation
---@field door_animation_up Animation
---@field door_animation_down Animation
---@field recharging_animation Animation

---The sprite data a `roboport_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) RoboportSpriteSet : EntityWithHealthSpriteSet
---The sprites making up the roboport, spread across the prototype's own fields.
---@field graphics_set RoboportGraphicsSet

---The applicator for roboports.
---@class (exact) RoboportSpriteSetApplicator : SpriteSetApplicator<RoboportPrototype, RoboportSpriteSet>
