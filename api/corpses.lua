---@using data

---@namespace Reskins.Assets

local _defines = require("api.defines")
local _sprite_utils = { utils = require("__reskins-sprite-utils__.utils") }
local Assignment = require("api.assignment")
local GenericRemnants = require("assets.base.generic-remnants")

---Provides methods for creating the corpse of an entity from the `corpse` of a sprite set, and for applying a
---`CorpseSpriteSet` to a corpse.
---
---#### Examples
---```lua
---local Corpses = require("__reskins-assets-api__.api.corpses")
---```
---@class Corpses
local _corpses = {}

-- Each of these fields of a `CorpseSpriteSet` is applied to the field of the same name of the corpse prototype.
local corpse_fields = {
	"animation",
	"animation_overlay",
	"animation_overlay_final_render_layer",
	"animation_overlay_render_layer",
	"animation_render_layer",
	"collision_box",
	"decay_animation",
	"decay_frame_transition_duration",
	"direction_shuffle",
	"dying_speed",
	"expires",
	"final_render_layer",
	"flags",
	"ground_patch",
	"ground_patch_decay",
	"ground_patch_fade_in_delay",
	"ground_patch_fade_in_speed",
	"ground_patch_fade_out_duration",
	"ground_patch_fade_out_start",
	"ground_patch_higher",
	"ground_patch_render_layer",
	"hidden_in_factoriopedia",
	"order",
	"remove_on_entity_placement",
	"remove_on_tile_placement",
	"selectable_in_game",
	"shuffle_directions_at_frame",
	"splash",
	"splash_render_layer",
	"splash_speed",
	"subgroup",
	"time_before_removed",
	"time_before_shading_off",
	"underwater_layer_offset",
	"underwater_patch",
}

-- The generic remnants of the base game for an entity with a shorter side of each number of tiles.
---@type table<integer, EntityID>
local generic_remnants_by_side = {
	[1] = "small-remnants",
	[2] = "medium-small-remnants",
	[3] = "medium-remnants",
}

-- The number of tiles on each side of `medium-remnants`, which is repeated in a grid across a larger entity.
local MEDIUM_REMNANTS_SIDE = 3

-- The number of tiles by which neighboring copies of `medium-remnants` in a grid overlap, at least.
local MEDIUM_REMNANTS_OVERLAP = 1

-- The type names of the flying robots, which have no `corpse` and create their remnants when they fall to the ground.
local flying_robot_types = {
	["construction-robot"] = true,
	["logistic-robot"] = true,
	["combat-robot"] = true,
}

---Indicates whether the given `prototype` is a flying robot.
---@param prototype EntityWithHealthPrototype
---@return boolean
local function is_flying_robot(prototype)
	return flying_robot_types[prototype.type] == true
end

---Indicates whether the given `prototype` is placed off the tile grid.
---@param prototype EntityWithHealthPrototype
---@return boolean
local function is_off_grid(prototype)
	if is_flying_robot(prototype) then
		return true
	end

	for _, flag in pairs(prototype.flags or {}) do
		if flag == "placeable-off-grid" then
			return true
		end
	end

	return false
end

---Gets the width and height of the given bounding box, in either the named or the array form.
---@param bounding_box BoundingBox
---@return double width
---@return double height
local function get_bounding_box_dimensions(bounding_box)
	local left_top = (bounding_box.left_top or bounding_box[1]) --[[@as MapPosition]]
	local right_bottom = (bounding_box.right_bottom or bounding_box[2]) --[[@as MapPosition]]
	local left, top = _sprite_utils.utils.unpack_vector(left_top)
	local right, bottom = _sprite_utils.utils.unpack_vector(right_bottom)
	return right - left, bottom - top
end

---Gets the given length rounded up to a whole number of tiles, and at least 1.
---@param length double
---@return integer
local function round_up_to_tiles(length)
	-- Allow for floating point error in a length that is a whole number of tiles.
	return math.max(1, math.ceil(length - 1e-6))
end

---Gets the size of the given `prototype` in tiles. An entity on the tile grid takes its `tile_width` and `tile_height`,
---each of which defaults to the side of its collision box rounded up. An entity off the tile grid takes its selection
---box rounded up. Each side is at least 1.
---@param prototype EntityWithHealthPrototype
---@return integer width
---@return integer height
local function get_tile_size(prototype)
	local off_grid = is_off_grid(prototype)
	local bounding_box = off_grid and prototype.selection_box or prototype.collision_box

	local width, height = 1, 1
	if bounding_box then
		local box_width, box_height = get_bounding_box_dimensions(bounding_box)
		width, height = round_up_to_tiles(box_width), round_up_to_tiles(box_height)
	end

	if off_grid then
		return width, height
	end

	return prototype.tile_width or width, prototype.tile_height or height
end

---Gets a bounding box of the given `width` and `height`, centered on the origin.
---@param width double
---@param height double
---@return BoundingBox
local function get_centered_box(width, height)
	return { { -width / 2, -height / 2 }, { width / 2, height / 2 } }
end

---Gets the localised name of the given `prototype`.
---@param prototype EntityWithHealthPrototype
---@return LocalisedString
local function get_entity_localised_name(prototype)
	return prototype.localised_name and util.copy(prototype.localised_name) or { "entity-name." .. prototype.name }
end

---Applies the fields of the given `corpse_sprite_set` to the given `corpse`, in place.
---
---Each field that `corpse_sprite_set` defines is copied onto the field of the same name of `corpse`. A field that it
---does not define is not modified.
---@param corpse CorpsePrototype|CorpseSpriteSet The corpse, or the corpse of a sprite set, that takes the fields.
---@param corpse_sprite_set CorpseSpriteSet The artwork and the other fields of the corpse.
function _corpses.apply_corpse_sprite_set(corpse, corpse_sprite_set)
	Assignment.safe_assign(corpse, corpse_sprite_set, corpse_fields)
end

---Gets the given length rounded to the nearest whole number of tiles, and at least 1. A length halfway between two
---whole numbers of tiles is rounded down.
---@param length double
---@return integer
local function round_to_tiles(length)
	-- Allow for floating point error in a length that is halfway between two whole numbers of tiles.
	return math.max(1, math.ceil(length - 0.5 - 1e-6))
end

---Gets the size of the given `prototype` in whole tiles, for its generic remnants. The size is the selection box of
---`prototype` rounded to the nearest whole number of tiles, or the tile size of `prototype` when it has no selection
---box.
---@param prototype EntityWithHealthPrototype
---@return integer width
---@return integer height
local function get_generic_remnants_size(prototype)
	if prototype.selection_box then
		local width, height = get_bounding_box_dimensions(prototype.selection_box)
		if width > 0 and height > 0 then
			return round_to_tiles(width), round_to_tiles(height)
		end
	end

	return get_tile_size(prototype)
end

---Gets the position of each copy of `medium-remnants` in a grid along a side of the given number of `tiles`, in tiles
---from the center of the side. The outer copies meet the ends of the side, and neighboring copies overlap by at least
---`MEDIUM_REMNANTS_OVERLAP` tiles.
---@param tiles integer The number of tiles of the side, which is more than `MEDIUM_REMNANTS_SIDE`.
---@return double[]
local function get_grid_positions(tiles)
	local count = math.ceil((tiles - MEDIUM_REMNANTS_OVERLAP) / (MEDIUM_REMNANTS_SIDE - MEDIUM_REMNANTS_OVERLAP))
	local span = tiles - MEDIUM_REMNANTS_SIDE

	local positions = {}
	for i = 0, count - 1 do
		positions[#positions + 1] = -span / 2 + span * i / (count - 1)
	end

	return positions
end

---Gets a corpse that repeats the artwork of `medium-remnants` in a grid across a square of the given number of `tiles`
---on each side.
---
---Each variation of the corpse draws a copy of a variation of `medium-remnants` at each position of the grid. The
---copies next to each other in a row, a column, or a diagonal draw different variations of `medium-remnants`.
---@param tiles integer The number of tiles on each side of the square, which is more than `MEDIUM_REMNANTS_SIDE`.
---@return CorpseSpriteSet
local function get_grid_remnants(tiles)
	local corpse = GenericRemnants.get_corpse("medium-remnants")
	local source_variations = corpse.animation --[[@as RotatedAnimation[] ]]
	local positions = get_grid_positions(tiles)

	---@type RotatedAnimation[]
	local variations = {}
	for variation_index = 1, #source_variations do
		local layers = {}
		for row, y in pairs(positions) do
			for column, x in pairs(positions) do
				-- Each step along a row moves to the next variation, and each step along a column moves two variations.
				local source_index = (variation_index + column + 2 * row - 4) % #source_variations + 1
				local source = source_variations[source_index] --[[@as RotatedAnimation]]
				for _, layer in pairs(source.layers or { source }) do
					local shift_x, shift_y = _sprite_utils.utils.unpack_vector(layer.shift or { 0, 0 })
					local copy = util.copy(layer)
					copy.shift = { shift_x + x, shift_y + y }
					layers[#layers + 1] = copy
				end
			end
		end
		variations[variation_index] = { layers = layers }
	end

	corpse.animation = variations

	return corpse
end

---Gets the generic remnants for the size of the given `prototype`.
---
---The size of `prototype` is its selection box rounded to the nearest whole number of tiles, or its tile size when it
---has no selection box. An entity of 1 x 2 or 2 x 1 tiles takes `1x2-remnants`. Any other entity takes the generic
---remnants of the base game for its shorter side: `small-remnants` for 1 tile, `medium-small-remnants` for 2 tiles,
---and `medium-remnants` for 3 tiles. An entity with a shorter side of 4 tiles or more takes a corpse that repeats the
---artwork of `medium-remnants` in a grid across a square of that side, centered on the entity. The outer copies of the
---artwork meet the edges of the square, and neighboring copies overlap by at least 1 tile.
---@param prototype EntityWithHealthPrototype The entity for which the remnants are selected.
---@return EntityID|CorpseSpriteSet # The name of the generic remnants of the base game, or the corpse that repeats the artwork of `medium-remnants`.
---@nodiscard
function _corpses.get_generic_remnants(prototype)
	local width, height = get_generic_remnants_size(prototype)
	if (width == 1 and height == 2) or (width == 2 and height == 1) then
		return "1x2-remnants"
	end

	local side = math.min(width, height)
	if side <= MEDIUM_REMNANTS_SIDE then
		return generic_remnants_by_side[side]
	end

	return get_grid_remnants(side)
end

---Gets the name of the corpse that the given `corpse` of a sprite set gives the given `prototype`.
---@param prototype EntityWithHealthPrototype The entity to which the sprite set is applied.
---@param corpse? CorpseSpriteSet|EntityID|GenericRemnants The `corpse` of the sprite set.
---@return EntityID? # The name of the corpse, or `nil` when `corpse` is `nil`.
---@nodiscard
function _corpses.get_corpse_name(prototype, corpse)
	if corpse == _defines.generic_remnants then
		corpse = _corpses.get_generic_remnants(prototype)
	end

	if corpse == nil then
		return nil
	elseif type(corpse) == "string" then
		return corpse
	end

	return "ar-" .. prototype.name .. "-remnants"
end

---Creates the corpse of the given `prototype` from the given `corpse` of a sprite set, and sets it as the `corpse` of
---`prototype`, in place.
---
---A `CorpseSpriteSet` is created as the corpse `ar-<entity name>-remnants`, which replaces a corpse of that name. The
---corpse takes the fields of `corpse`, the size of `prototype`, the localised name `{"remnant-name", ...}`, and a copy of
---the icon of `prototype`. It takes no field from the corpse that `prototype` names.
---
---An `EntityID` is set as given. `_defines.generic_remnants` is replaced by the result of `get_generic_remnants` for
---`prototype`, which is then set or created in the same way. A flying robot creates its corpse when it falls to the
---ground, so the corpse is not set on it.
---@param prototype EntityWithHealthPrototype The entity to which the sprite set is applied.
---@param corpse? CorpseSpriteSet|EntityID|GenericRemnants The `corpse` of the scaled sprite set. When `nil`, `prototype` is not modified.
---@return EntityID? # The name of the corpse, or `nil` when `corpse` is `nil`.
function _corpses.apply(prototype, corpse)
	if corpse == _defines.generic_remnants then
		corpse = _corpses.get_generic_remnants(prototype)
	end

	local name = _corpses.get_corpse_name(prototype, corpse)
	if name == nil then
		return nil
	end

	if type(corpse) == "table" then
		---@type CorpsePrototype
		local remnants = { type = "corpse", name = name }
		_corpses.apply_corpse_sprite_set(remnants, corpse)

		local width, height = get_tile_size(prototype)
		if is_off_grid(prototype) and prototype.selection_box then
			local selection_width, selection_height = get_bounding_box_dimensions(prototype.selection_box)
			remnants.selection_box = get_centered_box(selection_width, selection_height)
		else
			remnants.selection_box = get_centered_box(width, height)
		end
		remnants.tile_width = width
		remnants.tile_height = height

		remnants.localised_name = { "remnant-name", get_entity_localised_name(prototype) }

		-- A corpse with the `placeable-neutral` flag requires an icon. An entity with no icon gives its corpse the icon of
		-- the generic remnants of the base game.
		if prototype.icons then
			remnants.icons = util.copy(prototype.icons)
		elseif prototype.icon then
			remnants.icon = prototype.icon
			remnants.icon_size = prototype.icon_size
		else
			remnants.icon = "__base__/graphics/icons/remnants.png"
		end

		data:extend({ remnants })
	end

	if not is_flying_robot(prototype) then
		prototype.corpse = name
	end

	return name
end

return _corpses
