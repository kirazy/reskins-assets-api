---@using data
---@using Reskins.Assets

---@namespace Reskins.Assets.Bobs.UiSprites

local _defines = require("api.defines")

local FILE = _defines.assets_source.bobs_assets .. "/graphics/ui-sprites/bulk-inserter-effect.png"

---Provides methods for getting the GUI sprite of the bulk inserter effect, `bulk-inserter-effect.png`.
---
---#### Examples
---```lua
---local BulkInserterEffect = require("__reskins-assets-api__.assets.bobs.ui-sprites.bulk-inserter-effect")
---```
---@class BulkInserterEffect
local M = {}

---Gets the GUI sprite of the bulk inserter effect, which the technology effects of the bulk inserter capacity bonus
---draw.
---@return data.Sprite # The sprite.
---
---#### Examples
---```lua
----- Set the modifier icon of the bulk inserter capacity bonus.
---local BulkInserterEffect = require("__reskins-assets-api__.assets.bobs.ui-sprites.bulk-inserter-effect")
---
---data.raw["utility-sprites"].default.bulk_inserter_capacity_bonus_modifier_icon = BulkInserterEffect.get_sprite()
---```
---@nodiscard
function M.get_sprite()
	---@type data.Sprite
	local sprite = {
		filename = FILE,
		priority = "extra-high-no-scale",
		width = 64,
		height = 64,
		mipmap_count = 4,
		generate_sdf = true,
		flags = { "icon" },
	}

	return sprite
end

return M
