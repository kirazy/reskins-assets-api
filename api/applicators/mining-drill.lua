---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

--- The version of the base mod that added the flipped graphics sets.
local FLIPPED_GRAPHICS_VERSION = "2.1.0"

---Applies a `mining_drill_sprite_set`-shaped `set` to `prototype`.
---@param prototype MiningDrillPrototype
---@param set MiningDrillSpriteSet
local function apply_sprite_set_to_mining_drill(prototype, set)
	prototype.graphics_set = util.copy(set.graphics_set)
	prototype.wet_mining_graphics_set = util.copy(set.wet_mining_graphics_set)

	-- The flipped sets are drawn only by a base mod that reads them; the fields are absent from
	-- the prototype entirely before 2.1.0.
	if helpers.compare_versions(mods["base"], FLIPPED_GRAPHICS_VERSION) >= 0 then
		---@diagnostic disable-next-line: inject-field
		prototype.graphics_set_flipped = util.copy(set.graphics_set_flipped)
		---@diagnostic disable-next-line: inject-field
		prototype.wet_mining_graphics_set_flipped = util.copy(set.wet_mining_graphics_set_flipped)
	end
end

---@param explosion ExplosionPrototype
---@param set MiningDrillSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type MiningDrillSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.mining_drill_sprite_set,
	apply_to = apply_sprite_set_to_mining_drill,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data a `mining_drill_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) MiningDrillSpriteSet : EntityWithHealthSpriteSet
---The prototype's `graphics_set`.
---@field graphics_set MiningDrillGraphicsSet?
---The prototype's `graphics_set_flipped`. Applies only to Factorio 2.1.
---@field graphics_set_flipped MiningDrillGraphicsSet?
---The prototype's `wet_mining_graphics_set`.
---@field wet_mining_graphics_set MiningDrillGraphicsSet?
---The prototype's `wet_mining_graphics_set_flipped`. Applies only to Factorio 2.1.
---@field wet_mining_graphics_set_flipped MiningDrillGraphicsSet?

---The applicator for mining drills.
---@class (exact) MiningDrillSpriteSetApplicator : SpriteSetApplicator<MiningDrillPrototype, MiningDrillSpriteSet>
