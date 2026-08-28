---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local meld = require("__core__.lualib.meld")

---Applies a `pipe_to_ground_sprite_set`-shaped `set` to `prototype`.
---@param prototype PipeToGroundPrototype
---@param set PipeToGroundSpriteSet
local function apply_sprite_set_to_pipe_to_ground(prototype, set)
	prototype.pictures = util.copy(set.pictures)
	prototype.frozen_patch = set.frozen_patch

	if prototype.fluid_box and set.fluid_box then
		meld(prototype.fluid_box, set.fluid_box--[[@as FluidBox]])
	end
end

---@param explosion ExplosionPrototype
---@param set PipeToGroundSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("Not implemented")
end

---@type PipeToGroundSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.pipe_to_ground_sprite_set,
	apply_to = apply_sprite_set_to_pipe_to_ground,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---The sprite data a `pipe_to_ground_sprite_set`-tagged `SpriteSetDefinition` carries.
---@class (exact) PipeToGroundSpriteSet : EntityWithHealthSpriteSet
---The prototype's `horizontal_window_bounding_box`.
---@field horizontal_window_bounding_box BoundingBox
---The prototype's `vertical_window_bounding_box`.
---@field vertical_window_bounding_box BoundingBox
---The prototype's `pictures`.
---@field pictures Sprite4Way
---The prototype's `frozen_patch`.
---@field frozen_patch Sprite4Way?
---Pipe graphics for the prototype's `fluid_box`.
---@field fluid_box FluidBoxGraphics

---The applicator for pipe-to-ground segments.
---@class (exact) PipeToGroundSpriteSetApplicator : SpriteSetApplicator<PipeToGroundPrototype, PipeToGroundSpriteSet>
