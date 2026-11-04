---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `storage_tank_sprite_set` to `prototype`.
---@param prototype StorageTankPrototype
---@param set StorageTankSpriteSet
local function apply_sprite_set_to_storage_tank(prototype, set)
	prototype.pictures = util.copy(set.pictures)
	prototype.window_bounding_box = util.copy(set.window_bounding_box)

	Assignment.safe_assign(prototype, set, { "circuit_connector" })
end

---@type StorageTankSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.storage_tank_sprite_set,
	apply_to = apply_sprite_set_to_storage_tank,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `storage_tank_sprite_set`.
---@class (exact) StorageTankSpriteSet : EntityWithHealthSpriteSet
---The prototype's `pictures`.
---@field pictures StorageTankPictures
---The location of the window showing the contents. Note that for `window_background` the width and height are
---determined by the sprite and window_bounding_box only determines the drawing location. For `fluid_background` the
---width is determined by the sprite and the height and drawing location are determined by window_bounding_box.
---
---See [StorageTankPrototype::window_bounding_box](https://lua-api.factorio.com/latest/prototypes/StorageTankPrototype.html#window_bounding_box).
---@field window_bounding_box BoundingBox
---When `nil`, the circuit connector of the prototype is not modified.
---@field circuit_connector? [CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition, CircuitConnectorDefinition]

---Applies the `StorageTankSpriteSet` to `StorageTankPrototype` instances.
---@class (exact) StorageTankSpriteSetApplicator : SpriteSetApplicator<StorageTankPrototype, StorageTankSpriteSet>
