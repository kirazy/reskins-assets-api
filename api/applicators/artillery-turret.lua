---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `artillery_turret_sprite_set` to `prototype`.
---@param prototype ArtilleryTurretPrototype
---@param set ArtilleryTurretSpriteSet
local function apply_sprite_set_to_artillery_turret(prototype, set)
	local graphics_set = util.copy(set.graphics_set)

	prototype.base_picture = graphics_set.base_picture
	prototype.base_picture_render_layer = graphics_set.base_picture_render_layer
	prototype.base_picture_secondary_draw_order = graphics_set.base_picture_secondary_draw_order
	prototype.cannon_base_shift = graphics_set.cannon_base_shift
	prototype.cannon_base_pictures = graphics_set.cannon_base_pictures
	prototype.cannon_barrel_pictures = graphics_set.cannon_barrel_pictures
	prototype.cannon_barrel_recoil_shiftings = graphics_set.cannon_barrel_recoil_shiftings
	prototype.cannon_barrel_recoil_shiftings_load_correction_matrix =
		graphics_set.cannon_barrel_recoil_shiftings_load_correction_matrix
	prototype.cannon_barrel_light_direction = graphics_set.cannon_barrel_light_direction

	Assignment.safe_assign(prototype, set, { "circuit_connector" })
end

---@type ArtilleryTurretSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.artillery_turret_sprite_set,
	apply_to = apply_sprite_set_to_artillery_turret,
}

---Defines the graphics set fields of an artillery turret.
---@class (exact) ArtilleryTurretGraphicsSet
---@field base_picture Animation4Way
---@field base_picture_render_layer? RenderLayer
---@field base_picture_secondary_draw_order? uint8
---@field cannon_base_shift Vector3D
---@field cannon_base_pictures RotatedSprite
---@field cannon_barrel_pictures RotatedSprite
---@field cannon_barrel_recoil_shiftings? Vector3D[]
---Only loaded if `cannon_barrel_recoil_shiftings` is loaded.
---
---See [ArtilleryTurretPrototype::cannon_barrel_recoil_shiftings_load_correction_matrix](https://lua-api.factorio.com/latest/prototypes/ArtilleryTurretPrototype.html#cannon_barrel_recoil_shiftings_load_correction_matrix).
---@field cannon_barrel_recoil_shiftings_load_correction_matrix? Vector3D[]
---Only loaded if `cannon_barrel_recoil_shiftings` is loaded.
---
---See [ArtilleryTurretPrototype::cannon_barrel_light_direction](https://lua-api.factorio.com/latest/prototypes/ArtilleryTurretPrototype.html#cannon_barrel_light_direction).
---@field cannon_barrel_light_direction? Vector3D

---Defines the sprite data in a `SpriteSetDefinition` of type `artillery_turret_sprite_set`.
---@class (exact) ArtilleryTurretSpriteSet : EntityWithHealthSpriteSet
---When `nil`, the circuit connector of the prototype is not modified.
---@field circuit_connector? CircuitConnectorDefinition
---The sprites of the artillery turret. Each field is copied onto the prototype field of the same name.
---@field graphics_set ArtilleryTurretGraphicsSet

---Applies the `ArtilleryTurretSpriteSet` to `ArtilleryTurretPrototype` instances.
---@class (exact) ArtilleryTurretSpriteSetApplicator : SpriteSetApplicator<ArtilleryTurretPrototype, ArtilleryTurretSpriteSet>
