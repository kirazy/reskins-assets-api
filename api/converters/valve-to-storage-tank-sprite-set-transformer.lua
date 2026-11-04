---@using data
---@using Reskins.Assets
---@using Reskins.Assets.Applicators

---@namespace Reskins.Assets.Converters

---Gets the given `animations` as a `Sprite4Way`, with the north animation in each direction that `animations` does not
---define.
---@param animations Animation4Way
---@return Sprite4Way
local function get_picture(animations)
	-- An animation with no `north` field applies to every direction.
	if animations.north == nil then
		return animations --[[@as Sprite4Way]]
	end

	return {
		north = animations.north --[[@as Sprite]],
		east = (animations.east or animations.north) --[[@as Sprite]],
		south = (animations.south or animations.north) --[[@as Sprite]],
		west = (animations.west or animations.north) --[[@as Sprite]],
	}
end

---Transforms a `ValveSpriteSet` into a `StorageTankSpriteSet`.
---
---The animations of the valve are the `picture` of the storage tank, and each animation is drawn as a sprite that shows
---its first frame. The frozen patch of the valve is the `frozen_patch` of the storage tank. The `window_bounding_box`
---is an empty box at the center of the entity, and no circuit connector is defined.
---
---Objects are assigned directly and are not copied.
---@param sprite_set ValveSpriteSet The sprite set to convert.
---@return StorageTankSpriteSet # `sprite_set` as a storage tank sprite set.
local function valve_to_storage_tank_sprite_set_transformer(sprite_set)
	---@type StorageTankSpriteSet
	local out_value = {
		pictures = {
			picture = get_picture(sprite_set.animations),
			frozen_patch = sprite_set.frozen_patch,
		},
		window_bounding_box = { { 0, 0 }, { 0, 0 } },
		fluid_boxes = sprite_set.fluid_boxes,
		heat_buffers = sprite_set.heat_buffers,
		pipe_material = sprite_set.pipe_material,
		light_flicker = sprite_set.light_flicker,
		nominal_height = sprite_set.nominal_height,
		nominal_width = sprite_set.nominal_width,
		integration_patch = sprite_set.integration_patch,
		integration_patch_render_layer = sprite_set.integration_patch_render_layer,
		dying_explosion = sprite_set.dying_explosion,
		corpse = sprite_set.corpse,
		water_reflection = sprite_set.water_reflection,
		drawing_box_vertical_extension = sprite_set.drawing_box_vertical_extension,
	}

	return out_value
end

---@type SpriteSetTransformer<ValveSpriteSet, StorageTankSpriteSet>
return valve_to_storage_tank_sprite_set_transformer
