---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `gate_sprite_set` to `prototype`.
---@param prototype GatePrototype
---@param set GateSpriteSet
local function apply_sprite_set_to_gate(prototype, set)
	prototype.vertical_animation = util.copy(set.vertical_animation)
	prototype.horizontal_animation = util.copy(set.horizontal_animation)
	prototype.vertical_rail_animation_left = util.copy(set.vertical_rail_animation_left)
	prototype.vertical_rail_animation_right = util.copy(set.vertical_rail_animation_right)
	prototype.horizontal_rail_animation_left = util.copy(set.horizontal_rail_animation_left)
	prototype.horizontal_rail_animation_right = util.copy(set.horizontal_rail_animation_right)
	prototype.vertical_rail_base = util.copy(set.vertical_rail_base)
	prototype.horizontal_rail_base = util.copy(set.horizontal_rail_base)
	prototype.wall_patch = util.copy(set.wall_patch)
end

---@type GateSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.gate_sprite_set,
	apply_to = apply_sprite_set_to_gate,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `gate_sprite_set`.
---@class (exact) GateSpriteSet : EntityWithHealthSpriteSet
---@field vertical_animation Animation
---@field horizontal_animation Animation
---@field vertical_rail_animation_left Animation
---@field vertical_rail_animation_right Animation
---@field horizontal_rail_animation_left Animation
---@field horizontal_rail_animation_right Animation
---@field vertical_rail_base Animation
---@field horizontal_rail_base Animation
---@field wall_patch Animation

---Applies the `GateSpriteSet` to `GatePrototype` instances.
---@class (exact) GateSpriteSetApplicator : SpriteSetApplicator<GatePrototype, GateSpriteSet>
