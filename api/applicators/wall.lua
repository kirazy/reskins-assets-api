---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `wall_sprite_set` to `prototype`.
---@param prototype WallPrototype
---@param set WallSpriteSet
local function apply_sprite_set_to_wall(prototype, set)
	prototype.pictures = util.copy(set.pictures)

	prototype.wall_diode_green = util.copy(set.wall_diode_green)
	prototype.wall_diode_green_light_top = util.copy(set.wall_diode_green_light_top)
	prototype.wall_diode_green_light_right = util.copy(set.wall_diode_green_light_right)
	prototype.wall_diode_green_light_bottom = util.copy(set.wall_diode_green_light_bottom)
	prototype.wall_diode_green_light_left = util.copy(set.wall_diode_green_light_left)

	prototype.wall_diode_red = util.copy(set.wall_diode_red)
	prototype.wall_diode_red_light_top = util.copy(set.wall_diode_red_light_top)
	prototype.wall_diode_red_light_right = util.copy(set.wall_diode_red_light_right)
	prototype.wall_diode_red_light_bottom = util.copy(set.wall_diode_red_light_bottom)
	prototype.wall_diode_red_light_left = util.copy(set.wall_diode_red_light_left)

	Assignment.safe_assign(prototype, set, { "connected_gate_visualization", "circuit_connector" })
end

---@type WallSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.wall_sprite_set,
	apply_to = apply_sprite_set_to_wall,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `wall_sprite_set`.
---@class (exact) WallSpriteSet : EntityWithHealthSpriteSet
---@field pictures WallPictures
---When `nil`, the circuit connector of the prototype is not modified.
---@field circuit_connector? CircuitConnectorDefinition
---When `nil`, the sprite of the prototype is not modified.
---@field connected_gate_visualization? Sprite
---@field wall_diode_green? Sprite4Way
---@field wall_diode_green_light_top? LightDefinition
---@field wall_diode_green_light_right? LightDefinition
---@field wall_diode_green_light_bottom? LightDefinition
---@field wall_diode_green_light_left? LightDefinition
---@field wall_diode_red? Sprite4Way
---@field wall_diode_red_light_top? LightDefinition
---@field wall_diode_red_light_right? LightDefinition
---@field wall_diode_red_light_bottom? LightDefinition
---@field wall_diode_red_light_left? LightDefinition

---Applies the `WallSpriteSet` to `WallPrototype` instances.
---@class (exact) WallSpriteSetApplicator : SpriteSetApplicator<WallPrototype, WallSpriteSet>
