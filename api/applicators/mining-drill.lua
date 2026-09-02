---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")

---Applies a `mining_drill_sprite_set`-shaped `set` to `prototype`.
---@param prototype MiningDrillPrototype
---@param set MiningDrillSpriteSet
local function apply_sprite_set_to_mining_drill(prototype, set)
	prototype.graphics_set = util.copy(set.graphics_set)
	prototype.wet_mining_graphics_set = util.copy(set.wet_mining_graphics_set)
	prototype.radius_visualisation_picture = util.copy(set.radius_visualisation_picture)
	prototype.base_picture = util.copy(set.base_picture)
	prototype.base_render_layer = util.copy(set.base_render_layer)

	-- Flipped support added in Factorio 2.1
	if helpers.compare_versions(mods["base"], "2.1.0") >= 0 then
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

---The sprite data of a `SpriteSetDefinition` of type `mining_drill_sprite_set`.
---@class (exact) MiningDrillSpriteSet : EntityWithHealthSpriteSet
---The prototype's `graphics_set`.
---@field graphics_set MiningDrillGraphicsSet?
---The prototype's `graphics_set_flipped`. Applies only to Factorio 2.1.
---@field graphics_set_flipped MiningDrillGraphicsSet?
---The prototype's `wet_mining_graphics_set`.
---@field wet_mining_graphics_set MiningDrillGraphicsSet?
---The prototype's `wet_mining_graphics_set_flipped`. Applies only to Factorio 2.1.
---@field wet_mining_graphics_set_flipped MiningDrillGraphicsSet?
---The prototype's `radius_visualisation_picture`.
---@field radius_visualisation_picture Sprite?
---@field base_picture? Sprite4Way
---@field base_render_layer? RenderLayer

---The applicator for mining drills.
---@class (exact) MiningDrillSpriteSetApplicator : SpriteSetApplicator<MiningDrillPrototype, MiningDrillSpriteSet>
