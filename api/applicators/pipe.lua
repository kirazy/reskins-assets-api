---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Applicators

local _defines = require("api.defines")
local meld = require("__core__.lualib.meld")

---Applies a `set` of type `pipe_sprite_set` to `prototype`.
---@param prototype PipePrototype
---@param set PipeSpriteSet
local function apply_sprite_set_to_pipe(prototype, set)
	local set_copy = util.copy(set)
	prototype.horizontal_window_bounding_box = set_copy.horizontal_window_bounding_box
	prototype.vertical_window_bounding_box = set_copy.vertical_window_bounding_box
	prototype.pictures = set_copy.pictures

	if prototype.fluid_box and set.fluid_box then
		-- TODO: This needs to not be a straight merge-across, but rather directionally-aware
		-- intelligent merging; additionally pipe_connections is not 1:1.
		-- prototype.fluid_box.pipe_connections = set_copy.fluid_box.pipe_connections

		prototype.fluid_box.render_layer = set_copy.fluid_box.render_layer
		prototype.fluid_box.draw_only_when_connected = set_copy.fluid_box.draw_only_when_connected
		prototype.fluid_box.pipe_covers = set_copy.fluid_box.pipe_covers
		prototype.fluid_box.pipe_covers_frozen = set_copy.fluid_box.pipe_covers_frozen
		prototype.fluid_box.pipe_picture = set_copy.fluid_box.pipe_picture
		prototype.fluid_box.pipe_picture_frozen = set_copy.fluid_box.pipe_picture_frozen
		prototype.fluid_box.mirrored_pipe_picture = set_copy.fluid_box.mirrored_pipe_picture
		prototype.fluid_box.mirrored_pipe_picture_frozen = set_copy.fluid_box.mirrored_pipe_picture_frozen
		prototype.fluid_box.secondary_draw_order = set_copy.fluid_box.secondary_draw_order
		prototype.fluid_box.secondary_draw_orders = set_copy.fluid_box.secondary_draw_orders
		prototype.fluid_box.enable_working_visualisations = set_copy.fluid_box.enable_working_visualisations
	end
end

---@param explosion ExplosionPrototype
---@param set PipeSpriteSet
local function apply_sprite_set_to_explosion(explosion, set)
	error("The applicator does not support explosions.")
end

---@type PipeSpriteSetApplicator
return {
	set_type = _defines.sprite_set_type.pipe_sprite_set,
	apply_to = apply_sprite_set_to_pipe,
	apply_to_explosion = apply_sprite_set_to_explosion,
}

---Defines the sprite data of a `SpriteSetDefinition` of type `pipe_sprite_set`.
---@class (exact) PipeSpriteSet : EntityWithHealthSpriteSet
---The prototype's `horizontal_window_bounding_box`.
---@field horizontal_window_bounding_box BoundingBox
---The prototype's `vertical_window_bounding_box`.
---@field vertical_window_bounding_box BoundingBox
---The prototype's `pictures`.
---@field pictures PipePictures
---Pipe graphics for the prototype's `fluid_box`.
---@field fluid_box FluidBoxGraphics

---Applies the `PipeSpriteSet` to `PipePrototype` instances.
---@class (exact) PipeSpriteSetApplicator : SpriteSetApplicator<PipePrototype, PipeSpriteSet>
