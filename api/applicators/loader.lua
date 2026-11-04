---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local Assignment = require("api.assignment")

---Applies a `set` of type `loader_sprite_set` to `prototype`.
---@param prototype LoaderPrototype
---@param set LoaderSpriteSet
local function apply_sprite_set_to_loader(prototype, set)
	prototype.belt_animation_set = util.copy(set.belt_animation_set)
	prototype.structure = util.copy(set.structure)
	Assignment.safe_assign(prototype, set, { "structure_render_layer" })
end

---@type LoaderSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.loader_sprite_set,
	apply_to = apply_sprite_set_to_loader,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `loader_sprite_set`.
---@class (exact) LoaderSpriteSet : TransportBeltConnectableSpriteSet
---@field structure LoaderStructure
---When `nil`, the structure render layer of the prototype is not modified.
---@field structure_render_layer? RenderLayer

---Applies the `LoaderSpriteSet` to `LoaderPrototype` instances.
---@class (exact) LoaderSpriteSetApplicator : SpriteSetApplicator<LoaderPrototype, LoaderSpriteSet>
