---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `set` of type `splitter_sprite_set` to `prototype`.
---@param prototype SplitterPrototype
---@param set SplitterSpriteSet
local function apply_sprite_set_to_splitter(prototype, set)
	prototype.belt_animation_set = util.copy(set.belt_animation_set)
	prototype.structure = util.copy(set.structure)
	prototype.structure_patch = util.copy(set.structure_patch)
	prototype.frozen_patch = util.copy(set.frozen_patch)
end

---@type SplitterSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.splitter_sprite_set,
	apply_to = apply_sprite_set_to_splitter,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `splitter_sprite_set`.
---@class (exact) SplitterSpriteSet : TransportBeltConnectableSpriteSet
---@field structure Animation4Way
---Drawn 1 tile north of `structure` when the splitter is facing east or west.
---
---See [SplitterPrototype::structure_patch](https://lua-api.factorio.com/latest/prototypes/SplitterPrototype.html#structure_patch).
---@field structure_patch? Animation4Way
---@field frozen_patch? Sprite4Way

---Applies the `SplitterSpriteSet` to `SplitterPrototype` instances.
---@class (exact) SplitterSpriteSetApplicator : SpriteSetApplicator<SplitterPrototype, SplitterSpriteSet>
