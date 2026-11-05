-- This file is generated from the source of the base game by reskins-workspace/tools/base_explosions/generate.py.

---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Base

local _sprites = require("__reskins-sprite-utils__.sprites")

local M = {}

---The name of a generic corpse of the base game that `assets.base.generic-remnants` duplicates.
---@alias BaseGenericRemnantsID
---| "medium-remnants"

---The function that creates the fields of each generic corpse of the base game other than its name, icon, and size, by
---the name of the corpse.
---@type table<BaseGenericRemnantsID, fun(): CorpseSpriteSet>
local definitions = {
	["medium-remnants"] = function()
		return {
			hidden_in_factoriopedia = true,
			flags = { "placeable-neutral", "building-direction-8-way", "not-on-map" },
			subgroup = "generic-remnants",
			order = "a-d-a",
			selectable_in_game = false,
			time_before_removed = 60 * 60 * 15,
			expires = false,
			final_render_layer = "remnants",
			remove_on_tile_placement = false,
			animation = _sprites.make_rotated_animation_variations_from_spritesheet(4, {
				filename = "__base__/graphics/entity/remnants/medium-remnants.png",
				line_length = 1,
				width = 236,
				height = 246,
				direction_count = 1,
				shift = util.by_pixel(0, -4.5),
				scale = 0.5,
			}),
		}
	end,
}

---Gets the generic corpse of the base game with the given `name`, with its artwork.
---
---The corpse has each field of the generic corpse of the base game other than its name, icon, and size. The result is
---a new table on each call.
---@param name BaseGenericRemnantsID The name of the generic corpse.
---@return CorpseSpriteSet # The corpse.
---@throws When `name` is not the name of a generic corpse that `assets.base.generic-remnants` duplicates.
---@nodiscard
function M.get_corpse(name)
	local definition = definitions[name]
	if definition == nil then
		error(string.format("The corpse '%s' is not duplicated in 'assets.base.generic-remnants'.", name))
	end

	return definition()
end

return M
