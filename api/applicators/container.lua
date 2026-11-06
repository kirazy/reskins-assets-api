---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `container_sprite_set` to `prototype`.
---@param prototype ContainerPrototype
---@param set ContainerSpriteSet
local function apply_sprite_set_to_container(prototype, set)
	prototype.picture = util.copy(set.picture)

	Assignment.safe_assign(prototype, set, { "circuit_connector" })
end

---@type ContainerSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.container_sprite_set,
	apply_to = apply_sprite_set_to_container,
}

---Defines the sprite data in a `SpriteSetDefinition` of type `container_sprite_set`.
---@class (exact) ContainerSpriteSet : EntityWithHealthSpriteSet
---The picture displayed for this entity.
---
---When `nil`, the picture of the prototype is removed.
---
---See [ContainerPrototype::picture](https://lua-api.factorio.com/latest/prototypes/ContainerPrototype.html#picture).
---@field picture? Sprite4Way
---If given, there must be exactly `direction_count` elements in the table.
---
---When `nil`, the circuit connector of the prototype is not modified.
---
---See [ContainerPrototype::circuit_connector](https://lua-api.factorio.com/latest/prototypes/ContainerPrototype.html#circuit_connector).
---@field circuit_connector? CircuitConnectorDefinition[]

---Applies the `ContainerSpriteSet` to `ContainerPrototype` instances.
---@class (exact) ContainerSpriteSetApplicator : SpriteSetApplicator<ContainerPrototype, ContainerSpriteSet>
