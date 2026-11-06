---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `equipment_sprite_set` to `prototype`, in place.
---@param prototype EquipmentPrototype
---@param set EquipmentSpriteSet
local function apply_sprite_set_to_equipment(prototype, set)
	prototype.sprite = util.copy(set.sprite)
end

---@type EquipmentSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.equipment_sprite_set,
	apply_to = apply_sprite_set_to_equipment,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `equipment_sprite_set`.
---
---The `nominal_width` and `nominal_height` of the set are the `shape.width` and `shape.height` of the equipment for
---which the artwork is designed, in cells of the equipment grid.
---@class (exact) EquipmentSpriteSet : SpriteSetBase
---The graphics to use when this equipment is shown inside an equipment grid.
---
---See [EquipmentPrototype::sprite](https://lua-api.factorio.com/latest/prototypes/EquipmentPrototype.html#sprite).
---@field sprite Sprite

---Applies the `EquipmentSpriteSet` to `EquipmentPrototype` instances.
---@class (exact) EquipmentSpriteSetApplicator : SpriteSetApplicator<EquipmentPrototype, EquipmentSpriteSet>
